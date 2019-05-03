#pragma target fte
float ( float year ) isLeapYear =
{
    return year % 400 == 0 || ( year % 4   == 0  &&  year % 100 != 0 );
}

float ( float year, float month, float day, float hour, float minute, float second ) getUnixTimeStamp =
{

    local float i;
    local float daysInMonth[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
    local float daysInLeapMonth[] = { 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
    local float value = 0;
    // Do some bounds checking
    // Note that double will still not be indefinite, and you should check what the boundaries for double are.
    // (this also changes per implementation, so you need to check limits.h or something like that)
    // It would be more logical and correct to limit to the range permitted by double than to arbitrarily limit a 0y.
    // If your program needs this limit, you should enforce it outside this function, because it doesn't belong here.

    local float * daysPerMonth = isLeapYear(year) ? daysInLeapMonth : daysInMonth;

    if
    (
            year   < 0  ||  year   > 3000
        ||  month  < 1  ||  month  > 12
        ||  day    < 1  ||  day    > daysPerMonth[ month-1 ]
        ||  hour   < 0  ||  hour   > 24
        ||  minute < 0  ||  minute > 60
        ||  second < 0  ||  second > 60
    )

        return 0;
        // it is problematic to do error handling with the return value, as all possible return values could be valid epochs as well.
        // at least by taking 0 you can use a boolean check like if( x = getUnixTimeStamp(...) ) -> valid.
        // The check will fail for 1970-01-01-00-00-00



    // Calculate the seconds since or to epoch
    // Formula for dates before epoch will subtract the full years first, and then add the days passed in that year.

    local float epoch       = 1970                  ; // UNIX epoch 01/01/1970
    local float sign        = year > epoch ? 1 : -1 ; // So we know whether to add or subtract leap days

    local float nleapdays   = 0                     ; // The number of leap days
    local float monthsNDays = 0                     ; // The number of days passed in the current year


    // Count the leap days
    for(i = min(year,epoch );  i < max( year, epoch );  i++ ) {
        if( isLeapYear( i )  )
            ++nleapdays;
    }

    // Calculate the number of days passed in the current year
    for(i = 1;  i < month;  i++ ) {

        monthsNDays += daysPerMonth[ i - 1 ];
    }

    float preValue = second + (minute * 60) + (hour*3600)
    preValue = preValue/864;

   // preValue = stof(substring(ftos(preValue),0,4)); 
    value = ((year - epoch) * 365 + sign * nleapdays + monthsNDays + day - 1);
    value = (value + (preValue/100))*86400;

    /*value = value + second; 
    value = value + (hour * 3600);
    value = value + minute * 60;*/
    
    /*bprint (2, "seconds: ");
    bprint(2, ftos(second));
    bprint(2, "\n");*/


    //value += second;
    return value;
}