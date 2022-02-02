clc;
clear;

utiliz = readcell('utiliz.txt', 'Delimiter',';');
contacts = readcell('contactos.txt');

IDs =[1:1:1000]; %cria vetor com userIDs 

sizeY = height(contacts);

%Contacts data-----------------------------------
contactsData = zeros(1000,2);
lastID = cell2mat(contacts(1,1));

position=1;
numContacts = -1;
for i=1:sizeY
    newID = cell2mat(contacts(i,1));
    if lastID ~= newID
        contactsData(lastID,:) = [position numContacts];

        position = i;
        numContacts = 0;
        lastID = newID;

        continue;
    else
        numContacts = numContacts + 1;
    end
end


contactsData(lastID,:) = [position numContacts];

clear lastID;
clear position;
clear numContacts;
clear sizeY;
clear newID;

%Country Data
NumOfHashes = 100; %Number of hashes

countryHash = zeros(NumOfHashes,1000);

for i=1:NumOfHashes

    for j=1 : 1000    
        
        
        theirContacts = getID(contactsData(j,:), contacts );
        theirContactsCountry = cell2mat(GetCountry( theirContacts, utiliz ));
        theirContactsLength = height(theirContacts);
        allHashes = zeros(theirContactsLength, 1);


        for l=1:theirContactsLength
            str = num2str(theirContactsCountry(l));
            str = [str num2str(i)];
            allHashes(l) = string2hash( str );
        end
        CountryHashes(i,j) = min(allHashes);
    end 
end



interestsHashes = zeros(NumOfHashes, 1000);


for i=1:NumOfHashes
    
    for j=1 : 1000
        theirInterests = utiliz(j, 6:20);
        allHashes = zeros(15, 1);

        
        for l=1:15
            missingCheck = ismissing(theirInterests{l});
            if sum(missingCheck) > 0 && length(missingCheck) == 1
                break;
            end

            str = theirInterests{l};

            str = [str num2str(i)];
            allHashes(l) = string2hash( str );
        end
        interestsHashes(i,j) = min(nonzeros(allHashes));
    end
end
fprintf('Done!\n');


function contactsID = getID(tuple, contacts)
    startPos = tuple(1);
    endPos = startPos + tuple(2);

    lines = startPos:endPos;
    contactsID = cell2mat(contacts(lines,2));

end

function country = GetCountry(ID, utiliz)
    country = utiliz(ID, 5);
end