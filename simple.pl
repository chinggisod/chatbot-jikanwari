# Define the timetable
my @timetable1 = (
    ['今治', '友浦', '木浦', '岩城', '佐島', '弓削', '生名', '土生'],
    ['6:25', '6:45', '7:00', '7:12', '7:19', '7:25', '7:30', '7:35'],
    ['7:50', '8:10', '8:25', '8:38', '8:45', '8:52', '8:58', '9:05'],
    ['9:50', '10:10', '10:30', '10:43', '10:50', '10:57', '11:03', '11:10'],
    ['12:40', '13:00', '13:20', '13:33', '13:40', '13:47', '13:53', '14:00'],
    ['14:40', '15:00', '15:20', '15:33', '15:40', '16:10', '16:15', '16:20'],
    ['17:25', '17:45', '18:00', '18:13', '18:20', '18:27', '18:33', '18:40'],
    ['18:40', '19:00', '19:15', '19:28', '19:35', '19:42', '19:48', '19:55']
);
my @timetable2 = (
    ['土生', '生名', '弓削', '佐島', '岩城', '木浦', '友浦', '今治'],
    ['6:30', '6:35', '6:40', '6:46', '6:53', '7:05', '7:20', '7:40'],
    ['7:40', '7:45', '7:50', '7:56', '8:03', '8:15', '8:30', '8:50'],
    ['10:10', '10:17', '10:23', '10:30', '10:37', '10:50', '11:10', '11:30'],
    ['12:50', '12:57', '13:03', '13:10', '13:17', '13:30', '13:50', '14:10'],
    ['16:00', '16:07', '16:13', '16:20', '16:27', '16:40', '17:00', '17:20'],
    ['17:10', '17:17', '17:23', '17:30', '17:37', '17:50', '18:10', '18:30'],
    ['18:45', '18:50', '18:55', '19:01', '19:08', '19:20', '19:40', '20:00']
);

# Define a hash that maps port names to indices in the timetable
my %port_indices1;
for my $i (0..$#timetable1) {
    for my $j (0..$#{$timetable1[$i]}) {
        $port_indices1{$timetable1[$i][$j]} = $j;
    }
}

my %port_indices2;
for my $i (0..$#timetable2) {
    for my $j (0..$#{$timetable2[$i]}) {
        $port_indices2{$timetable2[$i][$j]} = $j;
    }
}

# Ask for the current port and destination port
print "今、どこ～？（例：今治港、友浦港、木浦港、岩城港、佐島港、弓削港、生名港、土生港)\n";
my $current_port = <>;
chomp $current_port;
print "行きたい場所を教えてほしいゾ。（例：今治港、友浦港、木浦港、岩城港、佐島港、弓削港、生名港、土生港）\n";
my $destination_port = <>;
chomp $destination_port;

# Determine which direction the user is going based on the current and destination ports
my $direction;
if (exists $port_indices1{$current_port} && exists $port_indices1{$destination_port}) {
    if ($port_indices1{$current_port} < $port_indices1{$destination_port}) {
        $direction = 1;
        #print($direction);
    } else {
        $direction = 2;
        #print($direction);
    }
}
if (!defined $direction) {
    print "オラ、その場所は知らないゾ～ \n";
    exit;
}

# Ask for the time the user wants to ride the ferry
print "何時に行きたいんだ？（例：〇時に行きたい）\n";
my $requested_time = <>;
chomp $requested_time;

# Check the timetable and find the nearest departure time
my $departure_time;
my $arrival_time;
if ($direction == 1) {
    ($departure_time, $arrival_time) = find_nearest_departure_time(\@timetable1, $port_indices1{$current_port}, $port_indices1{$destination_port}, $requested_time);
} elsif ($direction == 2) {
    ($departure_time, $arrival_time) = find_nearest_departure_time(\@timetable2, $port_indices2{$current_port}, $port_indices2{$destination_port}, $requested_time);
}

# Print the departure and arrival times
print "$departure_time に出て〜、\n";
print "$arrival_time に $destination_port に着く、 快速線があるゾ。\n";

# Find the nearest departure time in the given timetable
sub find_nearest_departure_time {
    my ($timetable, $current_port_index, $destination_port_index, $requested_time) = @_;

    # Convert the requested time to minutes
    my ($requested_hour, $requested_minute) = split /:/, $requested_time;
    my $requested_time_minutes = ($requested_hour * 60) + $requested_minute;

    # Find the nearest departure time
    my $nearest_departure_time;
    my $nearest_arrival_time;
    my $min_diff = 24 * 60; # Initialize the minimum difference to a large value
    for my $i (1..$#$timetable) {
        # Convert the departure time to minutes
        my ($departure_hour, $departure_minute) = split /:/, $timetable->[$i][$current_port_index];
        my $departure_time_minutes = ($departure_hour * 60) + $departure_minute;

        # Calculate the difference between the requested time and the departure time
        my $diff = $departure_time_minutes - $requested_time_minutes;
        if ($diff < 0) {
            $diff += 24 * 60; # Add one day's worth of minutes if the difference is negative
        }

        # If the difference is smaller than the current minimum difference, update the nearest departure time and arrival time
        if ($diff < $min_diff) {
            $min_diff = $diff;
            $nearest_departure_time = $timetable->[$i][$current_port_index];
            $nearest_arrival_time = $timetable->[$i][$destination_port_index];
        }
    }

    return ($nearest_departure_time, $nearest_arrival_time);
}
