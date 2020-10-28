#!/usr/bin/env ruby

require 'optparse'
require 'sqlite3'

DB_PATH = "#{ENV["HOME"]}/db/comicdb/comic.db"

def author_id db, author
  aid = db.execute('select id from author where name1=? or name2=? or name3=?', author, author, author)
  if aid.empty?
    db.execute('insert into author (name1, name2, name3) values (?, ?, ?)', author, '', '')
    aid = db.execute('select last_insert_rowid()')
  end
  aid[0][0]
end

def circle_id db, circle
  cid = db.execute('select id from circle where name=?', circle)
  if cid.empty?
    db.execute('insert into circle (name) values (?)', circle)
    cid = db.execute('select last_insert_rowid()')
  end
  cid[0][0]
end

def status_id db, stat
  sid = db.execute('select id from status where name=?', stat)
  if sid.empty?
    $stderr.puts "Wrong status name"
    exit 1
  end
  sid[0][0]
end

def book_id db, book, page, size, stat
  db.execute('insert into book (name, page, size, status) values (?, ?, ?, ?)', book, page, size, stat)
  bid = db.execute('select last_insert_rowid()')
  bid[0][0]
end

def update_book db, bid, page, size, stat
    db.execute('update book set page=?, size=?, status=? where id=?', page, size, stat, bid)
end

def stat_to_sym stat
  case stat
    when 'got'; '*'
    when 'ignored'; ' '
    else; '?'
  end
end

def dir_info path
  unless File.directory? path
    $stderr.puts "Path is not a directory"
    exit 1
  end
  n = Dir.entries(path).size - 2
  if n <= 0
    $stderr.puts "No file in the directory"
    exit 1
  end
  size = IO.popen(['du.m', path]) {|x| x.readline.to_f} rescue exit(1)
  [n, size]
end

def update_circle_member db, circle, member
  cid = circle_id db, circle
  aid = author_id db, member
  db.execute('insert into circle_member (circle, member) values (?, ?)', cid, aid) rescue nil
end

def update_doujinshi db, circle, name, stat, path
  page, size = stat == "got" ? dir_info(path) : [0, 0]
  cid = circle_id db, circle
  sid = status_id db, stat
  d = db.execute('select b.id from doujinshi as d, circle as c, book as b '+
                 'where d.circle=c.id and d.book=b.id and c.id=? and b.name=?', cid, name)
  if d.empty?
    bid = book_id db, name, page, size, sid
    db.execute('insert into doujinshi (circle, book) values (?, ?)', cid, bid) rescue nil
  else
    update_book db, d[0][0], page, size, sid
  end
end

def update_manga db, author, name, stat, path
  page, size = stat == "ignored" ? [0, 0] : dir_info(path)
  aid = author_id db, author
  sid = status_id db, stat
  m = db.execute('select b.id from manga as m, author as a, book as b '+
                 'where m.author=a.id and m.book=b.id and a.id=? and b.name=?', aid, name)
  if m.empty?
    bid = book_id db, name, page, size, sid
    db.execute('insert into manga (author, book) values (?, ?)', aid, bid) rescue nil
  else
    update_book db, m[0][0], page, size, sid
  end
end

def query_comic db, name
  q = '%' + name + '%'
  qs = {
    'manga' => [
      'select a.name1, b.name, b.page, b.size, s.name from ' +
      '(select * from author,manga where (name1 like ? or name2 like ? or name3 like ?) and id=author) as a left join (book as b, status as s) on ' +
      'a.book=b.id and b.status=s.id ' +
      'union ' +
      'select a.name1, b.name, b.page, b.size, s.name from ' +
      '(select * from book,manga where name like ? and id=book) as b left join (author as a, status as s) on ' +
      'b.author=a.id and b.status=s.id ',
      q, q, q, q
    ],
    'doujinshi' => [
      'select c.name, b.name, b.page, b.size, s.name from ' +
      '(select * from circle,doujinshi where name like ? and id=circle) as c left join (book as b, status as s) on ' +
      'c.book=b.id and b.status=s.id ' +
      'union ' +
      'select c.name, b.name, b.page, b.size, s.name from ' +
      '(select * from book,doujinshi where name like ? and id=book) as b left join (circle as c, status as s) on ' +
      'b.circle=c.id and b.status=s.id ',
      q, q
    ]
  }

  qs.each do |type, query|
    res = db.execute(*query)
    puts "#{type}"
    puts "================================================"
    res.each do |circle, title, page, size, stat|
      puts "[#{stat_to_sym stat}]\t[#{circle}] #{title}"
      puts "\t----------------------------------------"
      puts "\t#{page} p\t#{size.round 2} MB"
      puts
    end
    puts
  end
end

if __FILE__ == $0
  options = { }
  OptionParser.new do |opts|
    opts.on('-c', '--circle-member') {|v| options[:op] = :circle_member}
    opts.on('-d', '--doujinshi') {|v| options[:op] = :doujinshi}
    opts.on('-m', '--manga') {options[:op] = :manga}
  end.parse!

  db = SQLite3::Database.new DB_PATH
  case options[:op]
    when :circle_member
      circle, member = ARGV
      unless circle && member
        $stderr.puts "Wrong argument number"
        exit 1
      end
      update_circle_member db, circle, member
    when :doujinshi
      stat, circle, name, path = ARGV
      unless stat && circle && name && path
        $stderr.puts "Wrong argument number"
        exit 1
      end
      update_doujinshi db, circle, name, stat, path
    when :manga
      stat, author, name, path = ARGV
      unless stat && author && name && path
        $stderr.puts "Wrong argument number"
        exit 1
      end
      update_manga db, author, name, stat, path
    else
      name = ARGV[0]
      unless name
        $stderr.puts "Wrong argument number"
        exit 1
      end
      query_comic db, name
  end
end
