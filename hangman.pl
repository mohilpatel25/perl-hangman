use strict;
use feature 'say';

my @wrong_guesses = ();
my @guesses = ();
my @body;

my $line = new_word();
my @temp = split(' - ', $line);
my $the_word = $temp[0];

my $solved = 0;

do {
	system("cls");
    compute_body();
    draw();
    get_new_letter();
} until ($#wrong_guesses eq 5 or is_solved());

if ($#wrong_guesses eq 5) {
    say "\nMan is hung.";
}
else {
    say "\nYou guessed the word!.";
}

say "";
say "The word is";
say $line;

sub new_word {
    open(fh, '<', 'words.txt');
    my @lines = ();
    while(<fh>){
        push @lines, $_;
    }
    return $lines[rand scalar @lines];
}

sub draw {
    say " _____";
    say " |    |";
    say " |   ", sprintf(" %s", $body[0] || ' ');
    say " |   ", sprintf("%s%s%s", $body[1] || ' ', $body[3] || ' ', $body[2] ||  ' ');
    say " |   ", sprintf("%s %s", $body[4] || ' ', $body[5] || ' ');
    say " |";

    print "Letters available: ";
    for my $l ('a'..'z') {
        if (grep /$l/, @guesses) {
            print "_";
        }
        else {
            print $l;
        }
    }
    print "\n";

    say "Meaning - $temp[1]";

    for my $c (split //, $the_word) {
        if (grep /$c/, @guesses) {
            print "$c ";
        }
        else {
            print "_ ";
        }
    }
    print "\n";
}

sub compute_body {
    my @full_body = qw(O / \\ | / \\); 
    for my $i (0..$#wrong_guesses) {
        $body[$i] = $full_body[$i];
    }
}

sub get_new_letter {
    print "Enter your guess: ";
    my $guess = <STDIN>;
    chomp $guess;

    if (grep /$guess/, @guesses) {
        say "You've already tried that.";
    }
    else {
        if (grep /$guess/, (split //, $the_word)) {
            say "Yes, there is a '$guess' in the word!";
            push @guesses, $guess;
        }
        else {
            say "No, there is no '$guess' in the word!";
            push @guesses, $guess;
            push @wrong_guesses, $guess;
        }
    }
}

sub is_solved {
    for my $l (split //, $the_word) {
        if (! grep /$l/, @guesses) {
            return 0;
        }
    }
    return 1;
}