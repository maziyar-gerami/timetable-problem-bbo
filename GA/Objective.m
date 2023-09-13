function [ E_minusScore, P_minusScore, S_minusScore, j_minusScore, B_minusScore  ] = Objective( x, type,nDays, nSlots )
%OBJECTIVE Summary of this function goes here
%   Detailed explanation goes here
    type = type';
    
    for i=1:length(x)
        
        if(x(i)==0)
           
            sortedType(i)=1;
            
        else
            
            sortedType(i) = type(x(i));
            
        end
        
        
        
    end
    
    row=1;
    col=1;
    
    for i=1:nDays*nSlots
        
        if~(mod(i,nSlots))
            table(row, col) = x(i);
            tableSortedType(row, col) = sortedType(i);
            col = col+1;
            row = 1;
        
        end
        
        table(row, col) = x(i);
        tableSortedType(row, col) = sortedType(i);
        row=row+1;
    end

    table = table';
    tableSortedType = tableSortedType';
    table = table(1:nDays, 1:nSlots);
    tableSortedType = tableSortedType(1:nDays, 1:nSlots);
    
 
    
%1: Ekhtesasi courses would be better not to be in a row
    E_minusScore = 1;
    
    for i=1:nDays
        
        temp = tableSortedType(i,:);
        
        for j=1:nSlots-1
       
            if (temp(j)==temp(j+1) && temp(j)==2);

               E_minusScore = E_minusScore+1;

            end
            
        end
        
    end


%2: Paye courses would be better not to be in a row
    P_minusScore=1;
    for i=1:nDays
        
        temp = tableSortedType(i,:);
        
        for j=1:nSlots-1
       
            if (temp(j)==temp(j+1) && temp(j)==3);

               P_minusScore = P_minusScore+1;

            end
            
        end
        
    end
    


%3: Spare time between classes is not acceptable @@@@@@@@@@@@@@@@@@@@@@@@@@
    S_minusScore =1;
    
    for i=1:length(x)-1
       
        if (x(i)==0);
            
           S_minusScore = S_minusScore+1;
            
        end
        
    end
    
   
    
    

%4: Do jalaseye darsi dar yek rooz nabashand
j_minusScore =1;
for i=1:nDays
    
   temp = table(i,:);
   
   [a, b] = hist(temp, unique(temp));
   
   if (find(a>1))
       
        j_minusScore = j_minusScore+1;
   
   end
    
end

%5: Behtare darsaye ekhtesasi dar ebtedaye rooz bashand

B_minusScore =1;
    
    for i=1:nDays
        
        temp = tableSortedType(i,:);
        
        for j=1:nSlots
       
            if (temp(j)==2 && j>nSlots/2 );

               B_minusScore = B_minusScore+1;

            end
            
        end
        
    end

