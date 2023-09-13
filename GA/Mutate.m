function [ y ] = Mutate( x,courseTable, teacherSlotTable, nCourses )

y=x;
feasible = false;

counter=1;
while(~feasible&& counter<100)
    
    first = randi(length(x)-1, 1,1);
    second = first+1;

    y(second) = x(first);
    y(first)=x(second);
    feasible = Feasible ( y, courseTable, teacherSlotTable, nCourses);
    counter=counter+1;
end



end

