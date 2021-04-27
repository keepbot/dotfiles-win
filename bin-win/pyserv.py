# -*- coding: utf-8 -*-
# python >= 3.6

# TODO: implement new class to allow forced stop
import http.server
import socketserver

PORT = 8080

Handler = http.server.SimpleHTTPRequestHandler

Handler.extensions_map={
    '.css': 'text/css',
    '.html': 'text/html',
    '.jpg': 'image/jpg',
    '.js': 'application/x-javascript',
    '.manifest': 'text/cache-manifest',
    '.png': 'image/png',
    '.svg': 'image/svg+xml',
    '.webapp': 'application/x-web-app-manifest+json',
    '': 'application/octet-stream', # Default
}

httpd = socketserver.TCPServer(("", PORT), Handler)

print("Server started at http://localhost:" + str(PORT))
try:
    httpd.serve_forever()
except KeyboardInterrupt:
    print("Stopping http server...")
    httpd.shutdown()
    httpd.server_close()
