clc;


while 1
    msg1 = 'Insert Valid User ID : ';
    ID = input(msg1);
    
    if ID <= 1000 && ID >= 1
        break;
    end

end

while 1

    fprintf('1 = Your Contacts\n');
    fprintf('2 = Interests from most similar user\n')
    fprintf('3 = Search Name\n');
    fprintf('4 = Find most similar contacts based in list of interests\n');
    fprintf('5 = Exit\n')
    msg2 = 'Select choice : ';

    opcao = input(msg2);

     switch opcao

       case 1
          fprintf('\nYour Contacts\n');
          opcao1(ID, contactsData, contacts, utiliz);

       case 2
          fprintf('\n\tInterests from most similar user\n');
          opcao2(ID, CountryHashes, NumOfHashes, utiliz);

       case 3
          opcao3(searchHashes,utiliz,Bloom)
          fprintf('\nThis option in not working right now.')

       case 4
          fprintf('\n\tFind most similar contacts based in list of interests...\n');
          opcao4(ID, contactsData, contacts, utiliz, interestsHashes, NumOfHashes);

       case 5
          exitFlag = 1;
          fprintf('Program ended!\n');
          break;
     end
end
% ----------------------------------------------------FUNÇAO 1 ----------------------------------------------------
function contactsID = opcao1(ID, contactsData, contacts, utiliz)
    lines = getContacts(contactsData(ID,:));
    contactsID = cell2mat(contacts(lines,2));

    for i = 1 : length(contactsID)
        contactID = cell2mat(utiliz(contactsID(i), 1));
        nameContact = num2str(cell2mat(utiliz(contactsID(i), 3)));
        apelidoContact = num2str(cell2mat(utiliz(contactsID(i), 2)));

        fprintf('\tID : %d          Name : %s %s \n', contactID, nameContact, apelidoContact);

    end
    fprintf('\n');

end
% ----------------------------------------------------FUNÇAO 2 ----------------------------------------------------
function opcao2(ID, CountryHashes, NumOfHashes, utiliz)
    counter = zeros(1000,1);
    
    for i=1:NumOfHashes
        C = CountryHashes(NumOfHashes,:) == CountryHashes(NumOfHashes,ID);
    
        counter(C) = counter(C) + 1;
    end
    
    maximumCount = max(counter);
    fprintf('\t');

    for i = 1 : length(counter)

        if(counter(i) ~= maximumCount)
            continue;
        end

        contactID = cell2mat(utiliz(i,1));
        theirInterests = utiliz( contactID, 6:20 );

        for l=1:15
            missingCheck = ismissing(theirInterests{l});
            if sum(missingCheck) > 0 && length(missingCheck) == 1
                break;
            end
            fprintf('%s; ',theirInterests{l});
        end

        fprintf('\n');
        break;

    end
    fprintf('\n');
end


% ----------------------------------------------------FUNÇAO 4 ----------------------------------------------------
function opcao4(ID, contactsData, contacts, utiliz, interestsHashes, NumOfHashes)
    
    contactsID = opcao1(ID, contactsData, contacts, utiliz);
    while 1
        msg3 = 'Select A Contact´s ID : ';
        contactID = input(msg3);
        
        if ismember(contactID,contactsID) == 1
            break;
        end
    end 
    fprintf('\n\tShowing users...\n');

    counter = zeros(1000,1);
    
    for i=1:NumOfHashes
        C = interestsHashes(NumOfHashes,:) == interestsHashes(NumOfHashes,ID);
        counter(C) = counter(C) + 1;
    end

    maximumCount = max(counter);
    c = 1;
    for i = 1 : length(counter)

        if(counter(i) ~= maximumCount || c > 4)
            continue;
        end
        c = c + 1;

        contactID = cell2mat(utiliz(i,1));
        nomeContact = num2str(cell2mat(utiliz(i,3)));
        apelidoContact = num2str(cell2mat(utiliz(i,2)));
    
        fprintf('\tID : %d          Name : %s %s \n', contactID, nomeContact, apelidoContact);

    end
    fprintf('\n');
end




%getContacts
function contacts = getContacts(tuple)
    startPos = tuple(1);
    endPos = startPos + tuple(2);

    
    contacts = startPos:endPos;
end
