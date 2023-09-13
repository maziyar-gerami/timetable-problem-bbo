clc;
clear;
close all;
rng(22)
t=cputime;
%% Problem Definition
nDays = 5;          % Number of working days per week
    
nSlots = 5;         % Number of slot times per day


nCourses = 14;                      %Number of courses


teacherTable =   [1 0 0 0 1 0 
                  2 1 1 0 0 1 
                  3 1 1 1 0 0 
                  3 1 1 1 0 0 
                  4 0 0 0 1 1 
                  5 1 0 1 0 0 
                  6 0 0 1 1 0 
                  7 1 1 1 0 0 
                  8 1 1 0 0 1 
                  9 1 0 0 1 0 
                  10 1 0 0 1 0 
                  11 1 1 0 0 0 
                  12 0 0 0 0 1 
                  13 0 0 0 1 1];
              teacherTable = teacherTable(1:nCourses,:);
                  
for i=1:nCourses
   
    l=1;
    
    for j=1:nDays
        
        
        
        for k=1:nSlots
            
            
            teacherSlotTable(i,l) =  teacherTable(i,j+1);
            l = l+1;
            
        end
        
    end   
    
end

teacherSlotTable = [teacherTable(:,1),teacherSlotTable];

             
courseTable = [ 1;2;1;1;1;1;2;2;2;2;1;1;1;1];
courseTypes = [ 3;1;1;1;1;1;3;2;3;2;2;1;1;1];   % 3:Paye, 2:Ekhtesasi 1:Omoomi

%% Bees Algorithm Parameters

MaxIt=50;          % Maximum Number of Iterations

nScoutBee=20;                           % Number of Scout Bees

nSelectedSite=round(0.5*nScoutBee);     % Number of Selected Sites

nEliteSite=round(0.4*nSelectedSite);    % Number of Selected Elite Sites

nSelectedSiteBee=round(0.5*nScoutBee);  % Number of Recruited Bees for Selected Sites

nEliteSiteBee=2*nSelectedSiteBee;       % Number of Recruited Bees for Elite Sites

r=0.04*(nDays*nSlots);	% Neighborhood Radius

rdamp=0.99;             % Neighborhood Radius Damp Rate

%% Initialization

% Empty Bee Structure
empty_bee.Table=[];
empty_bee.E_minusScore=[];
empty_bee.P_minusScore=[];
empty_bee.S_minusScore=[];
empty_bee.Cost=[];

% Initialize Bees Array
bee=repmat(empty_bee,nScoutBee,1);

% Create New Solutions
for i=1:nScoutBee
    
    feasible = false;
    
    while (~feasible)
    
        tempCourseTable = courseTable;

        tempTable = zeros(1,nDays*nSlots);
        
        imposible=false;

            for j=1:nCourses
                
                counter =1;
                
                while (tempCourseTable(j))
                    
                    accessible = teacherSlotTable(j,2:end);
                    accessible = find(accessible);

                    n = randi(length(accessible),1,1);

                    if (tempTable(accessible(n)) ==0)

                        tempCourseTable(j)=tempCourseTable(j)-1;
                        tempTable(accessible(n))=j;
                        counter =1;
                        
                    else
                        
                        counter = counter+1;
                        
                        if counter==100
                            
                           imposible=true; 
                           break;
                           
                        end

                    end
                    

                end
                
                if imposible


                    break;

                end


            end
        
            feasible = Feasible(tempTable, courseTable, teacherSlotTable,nCourses);
        
	end

        bee(i).Table = tempTable;
       [bee(i).E_minusScore, bee(i).P_minusScore,bee(i).S_minusScore, bee(i).j_minusScore,bee(i).B_minusScore] = Objective(bee(i).Table,courseTypes, nDays, nSlots);
        

    
end

[value , index] = Topsis(bee);

% Sort Population
bee=bee(index);

for i=1:nScoutBee
    
    bee(i).Cost = 1/value(i)+eps;
    
    
end

% Sort Population
[~, SortOrder]=sort([bee.Cost]);
bee=bee(SortOrder);

% Update Best Solution Ever Found
BestSol=bee(1);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);
t=cputime;
%% Bees Algorithm Main Loop

for it=1:MaxIt
    
    % Elite Sites
    for i=1:nEliteSite
        
        bestnewbee.Cost=+inf;
        
        for j=1:nEliteSiteBee
            newbee.Table=UniformBeeDance( bee(i).Table,courseTable, teacherSlotTable, nCourses );
            [newbee.E_minusScore, newbee.P_minusScore,newbee.S_minusScore, newbee.j_minusScore,newbee.B_minusScore] = Objective(bee(i).Table,courseTypes, nDays, nSlots);
            newbee.Cost=[];
            nBee = [bee;newbee];
            
            [value , index] = Topsis(nBee);
            
            idx = find(nScoutBee+1);
            tCost = value(idx);
            
            
            if tCost<value(1);
                
                bestnewbee=newbee;
                bestnewbee.tCost
                
            end
        end

        if bestnewbee.Cost<bee(i).Cost
            
            bee(i)=bestnewbee;
            
        end
        
    end
    
    % Selected Non-Elite Sites
    for i=nEliteSite+1:nSelectedSite
        
        bestnewbee.Cost=+inf;
        
        for j=1:nSelectedSiteBee
            newbee.Table=UniformBeeDance( bee(i).Table,courseTable, teacherSlotTable, nCourses );
            [newbee.E_minusScore, newbee.P_minusScore,newbee.S_minusScore, newbee.j_minusScore, newbee.B_minusScore] = Objective(bee(i).Table,courseTypes, nDays, nSlots);
            newbee.Cost=[];
            nBee = [bee;newbee];
            
            [value , index] = Topsis(nBee);
            
            idx = find(nScoutBee+1);
            tCost = value(idx);
            
            
            if tCost<value(1);
                
                bestnewbee=newbee;
                bestnewbee.tCost
                
            end
        end

        if bestnewbee.Cost<bee(i).Cost
            bee(i)=bestnewbee;
        end
        
    end
    
    % Non-Selected Sites
    for i=nSelectedSite+1:nScoutBee
        feasible = false;
    
    while (~feasible)
    
        tempCourseTable = courseTable;

        tempTable = zeros(1,nDays*nSlots);
        
        imposible=false;

            for j=1:nCourses
                
                counter =1;
                
                while (tempCourseTable(j))
                    
                    accessible = teacherSlotTable(j,2:end);
                    accessible = find(accessible);

                    n = randi(length(accessible),1,1);

                    if (tempTable(accessible(n)) ==0)

                        tempCourseTable(j)=tempCourseTable(j)-1;
                        tempTable(accessible(n))=j;
                        counter =1;
                        
                    else
                        
                        counter = counter+1;
                        
                        if counter==100
                            
                           imposible=true; 
                           break;
                           
                        end

                    end
                    

                end
                
                if imposible


                    break;

                end


            end
        
            feasible = Feasible(tempTable, courseTable, teacherSlotTable,nCourses);
        
	end

        bee(i).Table = tempTable;
       [bee(i).E_minusScore, bee(i).P_minusScore,bee(i).S_minusScore, bee(i).j_minusScore, bee(i).B_minusScore] = Objective(bee(i).Table,courseTypes, nDays, nSlots);

    end
    [value , index] = Topsis(bee);

    % Sort Population
    bee=bee(index);

    for i=1:nScoutBee

        bee(i).Cost = 1/value(i)+eps;


    end
    
    % Update Best Solution Ever Found
    BestSol=bee(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    % Damp Neighborhood Radius
    r=r*rdamp;
    
end

cpuTime = cputime-t;
%% Results
%% Results
    plot(BestCost)

    row=1;
    col=1;
    
    for i=1:nDays*nSlots
        
        if~(mod(i,nSlots))
            table(row, col) = BestSol.Table(i);
            col = col+1;
            row = 1;
        
        end
        
        table(row, col) = BestSol.Table(i);
        row=row+1;
    end

    table = table';
    table = table(1:nDays, 1:nSlots)
E_minusScore = BestSol.E_minusScore-1
P_minusScore = BestSol.P_minusScore-1
S_minusScore = BestSol.S_minusScore-1
j_minusScore = BestSol.j_minusScore-1
B_minusScore = BestSol.B_minusScore-1
cpuTime = cputime-t
