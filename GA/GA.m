clc;
clear;
close all;
rng(22);
t=cputime;
%% Problem Defination
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

%% GA Parameters

MaxIt=20;      % Maximum Number of Iterations

nPop=100;        % Population Size

pc=0.8;                 % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number of Offsprings (Parnets)

pm=0.1;                 % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants

mu=0.02;         % Mutation Rate

beta=8;         % Selection Pressure

%% Initialization

empty_individual.Table=[];
empty_individual.E_minusScore=[];
empty_individual.P_minusScore=[];
empty_individual.S_minusScore=[];
empty_individual.Cost=[];

pop=repmat(empty_individual,nPop,1);

for i=1:nPop
    
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

        pop(i).Table = tempTable;
        [pop(i).E_minusScore, pop(i).P_minusScore,pop(i).S_minusScore, pop(i).j_minusScore, pop(i).B_minusScore] = Objective(pop(i).Table,courseTypes, nDays, nSlots);
        

    
end

[value , index] = Topsis(pop);

% Sort Population
pop=pop(index);

for i=1:nPop
    
    pop(i).Cost = 1/value(i)+eps;
    
    
end

% Store Best Solution
BestSol=pop(1);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Store Cost
WorstCost=pop(end).Cost;


popGlobal =[];

%% Main Loop
it=1;
while (~isnan(BestCost))
    
    
    P=value/sum(value);
    
    % Crossover
    popc=repmat(empty_individual,nc/2,2);
    for k=1:nc/2
        
        %  Select Parents Indices
        i1=RouletteWheelSelection(P);
        i2=RouletteWheelSelection(P);

        % Select Parents
        p1=pop(i1);
        p2=pop(i2);
        
        % Apply Crossover
            
        [popc(k,1).Table, popc(k,2).Table]=Crossover(p1.Table,p2.Table, courseTable, teacherSlotTable, nCourses);
        
        [popc(k,1).E_minusScore, popc(k,1).P_minusScore,popc(k,1).S_minusScore, popc(k,1).j_minusScore, popc(k,1).B_minusScore] = Objective(popc(k,1).Table,courseTypes, nDays, nSlots);
        
        [popc(k,2).E_minusScore, popc(k,2).P_minusScore,popc(k,2).S_minusScore, popc(k,2).j_minusScore, popc(k,2).B_minusScore] = Objective(popc(k,2).Table,courseTypes, nDays, nSlots);
            

    end
    popc=popc(:);
    
    % Mutation
    popm=repmat(empty_individual,nm,1);
    for k=1:nm
        
        % Select Parent
        i=randi([1 nPop]);
        p=pop(i);
        
        % Apply Mutation    
            
        popm(k).Table=Mutate(p.Table, courseTable, teacherSlotTable, nCourses);
            

        % Evaluate Mutant
        [popm(k).E_minusScore, popm(k).P_minusScore,popm(k).S_minusScore, popm(k).j_minusScore,popm(k).B_minusScore] = Objective(popm(k).Table,courseTypes, nDays, nSlots);
        
        
    end
    
    % Create Merged Population
    pop=[pop
         popc
         popm]; %#ok
    
    popGlobal = [pop; popc]; 
    % Sort Population
    [value , index] = Topsis(pop);

    % Sort Population
    pop=pop(index);

    for i=1:length(pop)

        pop(i).Cost = 1/value(i)+eps;


    end
    
    % Update Worst Cost
    WorstCost=max(WorstCost,pop(end).Cost);
    
    % Truncation
    pop=pop(1:nPop);
    value=value(1:nPop);
    
    % Store Best Solution Ever Found
    BestSol=pop(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    it = it+1;
end

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