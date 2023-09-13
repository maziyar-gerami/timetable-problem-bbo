function [ x1,x2 ] = Crossover( x ,y, courseTable, teacherSlotTable, nCourses )

nSelect = 8;
feasible = false;

x1 = x;
x2= y;

while(~feasible)
    
    
    p = randi(length(x),1,nSelect);
    
    x1(p) = y(p);
    
    x2(p) = x(p);
    
    feasibleX1 = Feasible(x1, courseTable, teacherSlotTable, nCourses);
    feasibleX2 = Feasible(x2, courseTable, teacherSlotTable, nCourses);
    feasible = and(feasibleX1,feasibleX2);
    
    


end

