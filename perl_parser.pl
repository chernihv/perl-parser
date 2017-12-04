#!/usr/bin/env perl
use warnings;
use strict;
use Mojolicious::Lite;
use LWP::UserAgent;

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

my $FILE_NAME = 'log.txt';

get '/' => sub {
        my $c = shift;
        $c->render(template => 'index');
    };

post '/' => sub {
        my $c = shift;
        my $url = $c->param('url');
        my $user_agent = new LWP::UserAgent;
        my $response = $user_agent->get($url);
        my $headers = $response->protocol, ' ', $response->status_line, "\n";
        $headers .= $response->headers_as_string, "\n";
        my $title = $response->title();
        open(FILE, ">> $FILE_NAME");
        print FILE "Headers from $url with title '$title': \n$headers \n";
        close(FILE);
        $c->render(template => 'index', headers => $headers);
    };

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
<h1>Welcome to the Mojolicious real-time web framework!</h1>
To learn more, you can browse through the documentation
<%= link_to 'here' => '/perldoc' %>.

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
    <head>
      <meta charset="utf-8">
      <title><%= title %></title>
    </head>
    <body>
        <form method='post'>
            <label>Get headers from url</label>
            <br>
            <input name='url' placeholder='http://ya.ru'>
            <br>
            <button type="submit">Send</button>
        </form>
        <pre>
            <%= stash("headers") =%>
        </pre>
  </body>
</html>
