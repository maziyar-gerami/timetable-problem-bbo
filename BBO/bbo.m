clc;
clear;
close all;
rng(22)
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

%% BBO Parameters

MaxIt=200;          % Maximum Number of Iterations

nPop=50;            % Number of Habitats (Population Size)

KeepRate=0.8;                   % Keep Rate
nKeep=round(KeepRate*nPop);     % Number of Kept Habitats

nNew=nPop-nKeep;                % Number of New Habitats

% Migration Rates
mu=linspace(1,0,nPop);          % Emmigration Rates
lambda=1-mu;                    % Immigration Rates

pMutation=0.1;

%% Initialization

% Empty Habitat
habitat.Table=[];
habitat.E_minusScore=[];
habitat.P_minusScore=[];
habitat.S_minusScore=[];
habitat.Cost=[];

% Create Habitats Array
pop=repmat(habitat,nPop,1);

% Initialize Habitats
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
       [pop(i).E_minusScore, pop(i).P_minusScore,pop(i).S_minusScore, pop(i).j_minusScore,pop(i).B_minusScore] = Objective(pop(i).Table,courseTypes, nDays, nSlots);
        

    
end

[value , index] = Topsis(pop);

% Sort Population
pop=pop(index);

for i=1:nPop
    
    pop(i).Cost = 1/value(i)+eps;
    
    
end

% Sort Population
[~, SortOrder]=sort([pop.Cost]);
pop=pop(SortOrder);

% Best Solution Ever Found
BestSol=pop(1);

% Array to Hold Best Coverages
BestCost=zeros(MaxIt,1);
t=cputime;

%% BBO Main Loop
it=1;
while( ~isnan(BestSol.Cost))
    
    newpop=pop;
    for i=1:nPop
        for k=1:nDays*nSlots
            % Migration
            if rand<=lambda(i)
                % Emmigration Probabilities
                EP=mu;
                EP(i)=0;
                EP=EP/sum(EP);
                
                % Select Source Habitat
                j=RouletteWheelSelection(EP);
                
                % Migration
                
                feasible = false;
                
                newpop(i).Table=Migrate(newpop(i).Table,newpop(j).Table, courseTable, teacherSlotTable, nCourses);
            end
            
            % Mutation
            if rand<=pMutation
                
                newpop(i).Table=Mutate(newpop(i).Table,courseTable, teacherSlotTable, nCourses) ;
                
                
            end
        end
        
        % Evaluation
        [newpop(i).E_minusScore, newpop(i).P_minusScore,newpop(i).S_minusScore, newpop(i).j_minusScore,newpop(i).B_minusScore] = Objective(newpop(i).Table,courseTypes, nDays, nSlots);
    end
    
    % Sort New Population
    [value , index] = Topsis(newpop);

    % Sort Population
    newpop=newpop(index);

    for i=1:length(newpop)

        newpop(i).Cost = 1/value(i)+eps;


    end
    
    % Select Next Iteration Population
    pop=[pop(1:nKeep)
         newpop(1:nNew)];
     
    [value , index] = Topsis(pop);

    % Sort Population
    pop=pop(index);

    for i=1:length(pop)

        pop(i).Cost = 1/value(i)+eps;


    end
    

    
    % Update Best Solution Ever Found
    BestSol=pop(1);
    
    % Store Best Coverage Ever Found
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    it=it+1;
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
