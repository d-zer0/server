require 'socket'
require 'json'

host = 'localhost'
port = 2000

puts "[1]GET or [2]POST?"
input = gets.chomp

case input
when "1" # GET
	path = "index.html"
	# HTTP request
	request = "GET #{path} HTTP/1.0\r\n\r\n"
	socket = TCPSocket.open(host, port)
	socket.print(request)
	response = socket.read
	# print response
	headers, body = response.split("\r\n\r\n", 2)
	puts headers
	puts body
when "2" # POST
	print "Name: "
	name = gets.chomp
	print "Email: "
	email = gets.chomp
	hash = { viking: {name: name, email: email} }

	path = "index.html"
	# HTTP request
	request = "POST #{path} HTTP/1.0\r\nContent-Length: #{hash.to_json.size}\r\n #{hash.to_json}\r\n\r\n"
	socket = TCPSocket.open(host, port)
	socket.print(request)
	response = socket.read
	puts response
end