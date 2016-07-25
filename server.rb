require 'socket'

server = TCPServer.open(2000)
loop {
	client = server.accept
	client.puts(Time.now.ctime)

	input = client.gets
	request = Request.new(input)

	verb = request.get_verb
	path = request.get_path

	if (verb == "GET")
		path.exist? ? status = "200" : status = "404"
		client.puts "Status: #{status}"
		if status == "200"
			path.open
			content = path.each {|line| client.puts line}
			path.close
			client.puts "Length: #{content.length}"
		elsif status == "404"
			client.puts "File not found."
		else
			client.puts "Unknown error."
		end
	end

	client.puts "Closing the connection. Bye!"
	client.close
}

class Request
	def initialize(input)
		@request = input
	end

	def get_verb
		# URL that generated this code:
		# http://txt2re.com/index-ruby.php3?s=GET%20/path/to/file/index.html%20HTTP/1.0&15

		#!/usr/bin/ruby
		txt=@request

		re1='((?:[a-z][a-z]+))'	# Word 1
		re=(re1)
		m=Regexp.new(re,Regexp::IGNORECASE);
		if m.match(txt)
			word1=m.match(txt)[1];
			#puts "("<<word1<<")"<< "\n"
			word1
		end
	end

	def get_path
		# URL that generated this code:
		# http://txt2re.com/index-ruby.php3?s=GET%20/path/to/file/index.html%20HTTP/1.0&1

		#!/usr/bin/ruby
		txt=@request
		re1='.*?'	# Non-greedy match on filler
		re2='((?:\\/[\\w\\.\\-]+)+)'	# Unix Path 1

		re=(re1+re2)
		m=Regexp.new(re,Regexp::IGNORECASE);
		if m.match(txt)
		    unixpath1=m.match(txt)[1];
		    #puts "("<<unixpath1<<")"<< "\n"
		    unixpath1
		end
	end
end