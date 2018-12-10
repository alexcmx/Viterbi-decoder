recv = ["11" "01" "00" "10" "10" "11"];
a=[11 12 23 24 31 32 43 44];
b = {"00", "11", "01", "10","11","00","10","01"};
dictionary = containers.Map(a,b); 
weight = [];
Trace = [1 1 0 0;1 1 2 2];
if length(recv)>3
    a = [];
    weight = [Hamming_distance(char(dictionary(11)),char(recv(1))) ...
        Hamming_distance(dictionary(12),recv(1)) 0 0]; 
    % Расчитывает первые 2 стрелки от начальной позиции 00
    weight = [weight; Hamming_distance(dictionary(11),recv(2))+weight(1,1) ...
        Hamming_distance(dictionary(12),recv(2))+weight(1,1) ...
        Hamming_distance(dictionary(23),recv(2))+weight(1,2) ...
        Hamming_distance(dictionary(24),recv(2))+weight(1,2)];
    % Расчитывает второй этап где есть все четыре столбца в строке, далее
    % цикл
    for n = 3:length(recv)
        weight = [weight; Mini(Hamming_distance(dictionary(11),recv(n))+weight(n-1,1),Hamming_distance(dictionary(31),recv(n))+weight(n-1,3),1,3,n-1,1) ...
            Mini(Hamming_distance(dictionary(12),recv(n))+weight(n-1,1),Hamming_distance(dictionary(32),recv(n))+weight(n-1,3),1,3,n-1,2)...
            Mini(Hamming_distance(dictionary(23),recv(n))+weight(n-1,2),Hamming_distance(dictionary(43),recv(n))+weight(n-1,4),2,4,n-1,3)...
            Mini(Hamming_distance(dictionary(24),recv(n))+weight(n-1,2),Hamming_distance(dictionary(44),recv(n))+weight(n-1,4),2,4,n-1,4)]; 
    % построены деревья с весами, осталось найти минимальный маршрут
    end
end




answer = solve(weight,Trace);
disp(translation(answer));

%функция которая выбирает минимум для каждой точки откуда в нее можно
%прийти и запоминает откуда. this- точка куда я пришел, last_punct -
%предыдущий ряд from1/2 предыдущая точка


function [minimum] = Mini(first, second,from1, from2, last_punct,this)
global Trace
minimum = min(first,second);
if first < second
    Trace(last_punct+1,this)=from1;% говорит что суда пришел из первой дорожки
else
    Trace(last_punct+1,this)=from2;
end
end

function [dist] = Hamming_distance (first,second)
dist = 0;
first = char(first);
second = char(second);
    if length(first)==length(second)
        for n=1:length(first)
            if first(n)~=second(n)
                dist = dist+1;
            end
        end
    end
end

function result = min2(c)
min = 10000;
result = 0;
for i=1:length(c)
    if c(i)<min
        min = c(i);
        result = i;
    end
end
end

function result = solve(weit, way) %endgame
len = length(weit(:,1));
pos = min2(weit(len,:));
result = pos;
for i=1:length(way)
    g = length(way)-i+1;
    result = [way(g,result(1)) result];
end

end

% converts [1 1] to 11
function result = magic_str2num(a)
a = string(a);
d = "";
for i=a
    d= d+i;
end
result = str2num(char(d));
end
%translates way to decoded code
function result = translation(a)
result ="";
d=[11 12 23 24 31 32 43 44];

b = {"0", "1", "0", "1", "0", "1", "0", "1"};
dict = containers.Map(d,b);
for i=1:length(a)-1
    result = result + dict(magic_str2num(a(i:i+1)));
end
end