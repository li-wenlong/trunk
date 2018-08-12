function [n, m] = CalculateMessageOffer( n, neighList )



receivedMessages = [];
sentMessages = [];

% if(length(n.neighbours) == 1)
%     if isa( n.funct, 'funct')
%         messageFunction = n.funct;
%     else
%         messageFunction = 1;
%     end
%     m{ 1 } = message( n.id, n.neighbours(1), n.step,  messageFunction);
% 
%     outboxItem.to =  n.neighbours(1);
%     outboxItem.message = m( length(m) );
%     n.outbox{ length(n.outbox)+ 1 } = outboxItem;
%     return
% end

for k = 1:length( n.messageFolder )
    receivedMessages( length(receivedMessages)+1 ) = n.messageFolder{k}.from;
end

for k = 1:length( n.outbox )
    sentMessages( length(sentMessages) +1  ) = n.outbox{k}.to;
end

% the ids of neighbours that has received messages before
sentMessages = unique(sentMessages,'legacy');
% the ids of neighbours that messages have been received before
receivedMessages = unique(receivedMessages,'legacy');

messageCount = 0;

for offerNum=1:length(neighList)
    % for all neighbours
    for checkFor = 1:length(n.neighbours)
        % check this one for
        
        % if they haven' t received any messages    
        if n.neighbours(checkFor) == neighList(offerNum)
            
            % Calculate message to n.neighbours(checkFor)
            if isa( n.funct, 'funct')
                % The message is that of a Function node in the form
                % \mu_{f \rightarrow x}(x) = \sum_{-x} f(X) \prod_{ h \in ne(f)\x} \mu_{y \rightarrow
                % f}(Y)
                
                % The below is the f(X) \prod_{ h \in ne(f)\x} \mu_{y \rightarrow f}(Y) part
                messageFunction = n.funct;
                for k = 1:length( n.messageFolder )
                    if n.messageFolder{k}.from ~= n.neighbours(checkFor)
                        messages = n.messageFolder{k}.messages; 
                        messageFunction = messageFunction*messages{ length(messages) }.function;
                    end
                end
                
                % The \sum_{-x} operation is applied during copy
                % construction
                messageCount = messageCount+1;
                m{ messageCount } = message( n.id, n.neighbours(checkFor), n.step, ...
                    marginalize( messageFunction, setdiff( get(messageFunction, 'domainLabels'), n.nDomainLabels{checkFor})) );
            else
                % The message is that of a Variable node in the form
                % \mu_{x \rightarrow f}(x) = \prod_{h \in ne(x)\f} \mu_{h
                % \rightarrow x}(x)
                
                % The below perform this product
                messageFunction = 1;
                for k = 1:length( n.messageFolder )
                    if n.messageFolder{k}.from ~= n.neighbours(checkFor)
                        messages = n.messageFolder{k}.messages; 
                        if ~isempty( messageFunction )
                            messageFunction = messageFunction*messages{length(messages)}.function;
                        end
                    end
                end
                
                messageCount = messageCount+1;
                m{ messageCount } = message( n.id, n.neighbours(checkFor), n.step, ...
                    messageFunction  );
            end % funct or variable node
            
            outboxItem.to =  n.neighbours(checkFor);
            outboxItem.message = m( length(m) );
            n.outbox{ length(n.outbox)+ 1 } = outboxItem;
        end % if match
    end % for neighbours
end % for offer

if messageCount==0
    m = {};
end

        