# ECE 2524 Homework 4  Problem  1  Jane Doe
{
    cnt=0;
    if(NR>1){
        print sqrt(($1-$3)*($1-$3)+($2-$4)*($2-$4));
        ++cnt;
    }
}
END{
    print "The number of computed distances is ", cnt;
}


