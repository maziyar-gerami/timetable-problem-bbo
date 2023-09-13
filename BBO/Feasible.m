function [ feasible ] = Feasible( x, courseTable, teacherSlotTable, nCourses)

    feasible = true;
% H1: all courses should be covered

        [counts, courses] = hist(x, unique(x));
        
        [courses, index] = sort (courses);
        
        counts = counts(index);
        
        counts = counts(1,2:end);
        
        if (~isequal(courseTable', counts))
            
            feasible = false;
            return

        end
        
% H2: teachers should be at uni
        for i=1:nCourses
            
           
            t = x.*teacherSlotTable(i,2:end);
            
            p = find(t==i);
            
            if isempty(p)
                feasible = false;
                return
                
            end
            
            
        end
       


