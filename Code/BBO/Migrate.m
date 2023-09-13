function [ popF ] = Migrate( x ,y, courseTable, teacherSlotTable, nCourses )

nSelect = 8;

popF =x;

x1 = x;
x2= y;
counter=1;
while(counter<100)
    
    
    p = randi(length(x),1,nSelect);
    
        p = randi(length(x),1,nSelect);
    
    x1(p) = y(p);
    
    x2(p) = x(p);
    
    feasibleX1 = Feasible(x1, courseTable, teacherSlotTable, nCourses);
    feasibleX2 = Feasible(x2, courseTable, teacherSlotTable, nCourses);
    
    if feasibleX1
        
        popF = x1;
        return;
        
    end
        
    if feasibleX2
        
        popF = x2;
        return;
        
    end
            

    counter=counter+1;

end

