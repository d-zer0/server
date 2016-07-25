require 'socket'
require 'json'

class Request
	def initialize(input)
		@request = input
	end

	def verb
		@request.split(" ")[0]
	end

	def path
		@request.split(" ")[1]
	end
end

# SERVER

server = TCPServer.open(2000)
loop {
	client = server.accept
	request = client.read_nonblock(256)
	client.puts(Time.now.ctime)
	client.puts "Request: #{request}"
	request = Request.new(request)

	verb = request.verb
	path = request.path

	client.puts "Path: #{path}"

	case verb
		
# GET REQUEST
	when "GET"
		begin
			file = File.open(path)
			status = 200
		rescue
			status = 404
		end
		client.puts "Status: #{status}"
		case status
		when 200
			client.puts "Contents:"
			client.puts
			content = file.each {|line| client.puts line}
			client.puts content
			client.puts
			client.puts "File length: #{content.to_s.length}"
			file.close
		when 404
			client.puts "File not found."
		end

# POST REQUEST
	when "POST"
		params = JSON.parse(request.to_s)
		client.puts params
	end

	client.puts "Closing the connection. Bye!"
	client.close
}