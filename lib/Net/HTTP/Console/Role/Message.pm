package Net::HTTP::Console::Role::Message;

use MooseX::Declare;

role Net::HTTP::Console::Role::Message {

    # XXX colors ?
    method logger($level, $message) {
        print "[".uc($level)."] ".$message."\n";
    }

    method print($message) {
        print $message."\n";
    }

}

1;
