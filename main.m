clear all
clc


% load('S5_session');
load('S4_session');

% Fp1 - lewe oko
% Fp2 - prawe oko

klasy_kontrolne = str2num(cell2mat(dane_wynikowe.Events{:, 3}));

% Podział sygnału na 3 sekundowe wycinki
% Częstotliwość próbkowania 250 Hz (3x250=750)
EEG = {};
for okno = 1:36
    EEG{okno} = dane_wynikowe.EEG_signal(:, 750*(okno-1)+1:750*okno);
end

% Wyświetlenie wszystkich próbek
for i = 1:36
    subplot(4, 9, i);
    plot(1:750, EEG{i});
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~(1)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

% Próby dla lewego i prawdego oka
Proby_12 = {};
klasy_12 =  [1, 2, 10, 11, 19, 20, 28, 29];
klasy_poprawne_12 = [];

for i = 1:length(klasy_12)
    Proby_12{i} = EEG{klasy_12(i)};
    klasy_poprawne_12 = [klasy_poprawne_12, klasy_kontrolne(klasy_12(i))];
end


% Rozpoznanie klasy na podstawie porównania maksymalnej
% wartości dla lewego i prawego kanału


klasy_rozpoznane_12 = [];

for i = 1:length(klasy_12)

    Fp1_max = max(Proby_12{i}(1, :));
    Fp2_max = max(Proby_12{i}(2, :));
    
    if Fp1_max > Fp2_max
        klasy_rozpoznane_12 = [klasy_rozpoznane_12, 1];
    else
        klasy_rozpoznane_12 = [klasy_rozpoznane_12, 2];
    end
    
end

% Sprawdzenie poprawności rozpoznanych klas
Poprawnosc_12 = 1 - sum(logical(abs(klasy_rozpoznane_12 - klasy_poprawne_12)))/length(Proby_12);


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~(2)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

% Rozpoznawanie lewego oka x1, x2 i x3 (klasy 1, 4, 7)

Proby_147 = {};
klasy_147 = [1:3:36];
klasy_poprawne_147 = [];

for i = 1:length(klasy_147)
    Proby_147{i} = EEG{klasy_147(i)};
    klasy_poprawne_147 = [klasy_poprawne_147, klasy_kontrolne(klasy_147(i))];
end

klasy_rozpoznane_147 = [];
skalar = 0.5;

for i = 1:length(klasy_147)

    peaks = findpeaks(Proby_147{i}(1, :), 'NPeaks', 3, 'MinPeakDistance', 30, 'SortStr', 'descend');
    
    if (peaks(1) * skalar) < peaks(2)
        if (peaks(2) * skalar) < peaks(3)
        klasy_rozpoznane_147 = [klasy_rozpoznane_147, 7];
        else
        klasy_rozpoznane_147 = [klasy_rozpoznane_147, 4];
        end
    else
        klasy_rozpoznane_147 = [klasy_rozpoznane_147, 1];
    end
    
end

Poprawnosc_147 = 1 - sum(logical(abs(klasy_rozpoznane_147 - klasy_poprawne_147)))/length(Proby_147);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~(3)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

% Sprawdzenie lewe, prawe czy oba
klasy_123 = [1, 2, 3, 10, 11, 12, 19, 20, 21, 28, 29, 30];
Proby_123 = {};
klasy_123 = [1, 2, 3, 10, 11, 12, 19, 20, 21, 28, 29, 30];
klasy_poprawne_123 = [];

for i = 1:length(klasy_123)
    Proby_123{i} = EEG{klasy_123(i)};
    klasy_poprawne_123 = [klasy_poprawne_123, klasy_kontrolne(klasy_123(i))];
end

klasy_rozpoznane_123 = [];

for i = 1:length(klasy_123)

    peaks = findpeaks(Proby_123{1}(1, :), 'NPeaks', 3, 'MinPeakDistance', 30, 'SortStr', 'descend');

    Fp1_max = max(Proby_123{i}(1, :));
    Fp2_max = max(Proby_123{i}(2, :));
    
    
    
    if Fp1_max > Fp2_max
        
        if (Fp2_max/Fp1_max) > 0.7
            klasy_rozpoznane_123 = [klasy_rozpoznane_123, 3];
        else
            klasy_rozpoznane_123 = [klasy_rozpoznane_123, 1];
        end
    else
        if (Fp1_max/Fp2_max) > 0.7
            klasy_rozpoznane_123 = [klasy_rozpoznane_123, 3];
        else
           klasy_rozpoznane_123 = [klasy_rozpoznane_123, 2]; 
        end
    end
    
end

Poprawnosc_123 = 1 - sum(logical(abs(klasy_rozpoznane_123 - klasy_poprawne_123)))/length(Proby_123);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~(4)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

Proby_36 = {};
klasy_36 = [1:1:36];
klasy_poprawne_36 = [];

for i = 1:length(klasy_36)
    Proby_36{i} = EEG{klasy_36(i)};
    klasy_poprawne_36 = [klasy_poprawne_36, klasy_kontrolne(klasy_36(i))];
end

klasy_rozpoznane_36 = [];
% (peak1 * skalar) < peak2
skalar = 0.5;

for i = 1:length(klasy_36)

    peaksL = findpeaks(Proby_36{i}(1, :), 'NPeaks', 3, 'MinPeakDistance', 30, 'SortStr', 'descend');
    peaksR = findpeaks(Proby_36{i}(2, :), 'NPeaks', 3, 'MinPeakDistance', 30, 'SortStr', 'descend');

    Fp1_max = max(Proby_36{i}(1, :));
    Fp2_max = max(Proby_36{i}(2, :));
    
    
    if (Fp2_max<Fp1_max) && ((Fp2_max/Fp1_max) > 0.7)
        if (peaksL(1) * skalar) < peaksL(2)
             if (peaksL(2) * skalar) < peaksL(3)
                 klasy_rozpoznane_36 = [klasy_rozpoznane_36, 9];
             else 
                 klasy_rozpoznane_36 = [klasy_rozpoznane_36, 6];
             end
        else
             klasy_rozpoznane_36 = [klasy_rozpoznane_36, 3];
        end
        
    elseif (Fp2_max>Fp1_max) && ((Fp1_max/Fp2_max) > 0.7)
          if (peaksR(1) * skalar) < peaksR(2)
             if (peaksR(2) * skalar) < peaksR(3)
                 klasy_rozpoznane_36 = [klasy_rozpoznane_36, 9];
             else 
                 klasy_rozpoznane_36 = [klasy_rozpoznane_36, 6];
             end
          else
             klasy_rozpoznane_36 = [klasy_rozpoznane_36, 3];
          end
    else
        if Fp1_max>Fp2_max
            if (peaksL(1) * skalar) < peaksL(2)
                if (peaksL(2) * skalar) < peaksL(3)
                   klasy_rozpoznane_36 = [klasy_rozpoznane_36, 7];
                else
                    klasy_rozpoznane_36 = [klasy_rozpoznane_36, 4];
                end
            else
                klasy_rozpoznane_36 = [klasy_rozpoznane_36, 1];
            end
        else
            if (peaksR(1) * skalar) < peaksR(2)
                if (peaksR(2) * skalar) < peaksR(3)
                   klasy_rozpoznane_36 = [klasy_rozpoznane_36, 8];
                else
                    klasy_rozpoznane_36 = [klasy_rozpoznane_36, 5];
                end
            else
                klasy_rozpoznane_36 = [klasy_rozpoznane_36, 2];
            end
        end
    end
end

Poprawnosc_36 = 1 - sum(logical(abs(klasy_rozpoznane_36 - klasy_poprawne_36)))/length(Proby_123);

%-------------------------PODSUMOWANIE----------------------------

Struktura_danych = [ "Wiersz 1: Numer badanego okna";
"Wiersz 2: Przypisana klasa z analizy";
"Wiersz 3: Klasa poprawna z danych wynikowych"]

Zadanie_1 = num2str([klasy_12; klasy_rozpoznane_12; klasy_poprawne_12])
Zadanie_2 = num2str([klasy_123; klasy_rozpoznane_123; klasy_poprawne_123])
Zadanie_3 = num2str([klasy_147; klasy_rozpoznane_147; klasy_poprawne_147])
Zadanie_4 = num2str([klasy_36; klasy_rozpoznane_36; klasy_poprawne_36])

Struktura_poprawnosci = ["Zadanie 1",Poprawnosc_12 ; "Zadanie 2",Poprawnosc_123;
 "Zadanie 3", Poprawnosc_147; "Zadanie 4",Poprawnosc_36]


%-------------------------TREŚĆ ZADANIA---------------------------

%1) 1,2 lewe czy prawe na podstawie 8 prób

%2) 1,4,7 Tylko lewe ale raz, dwa czy trzy - 12 prób

%3) 1,2,3 - 0,7 Pierwsze 3 kolumny (próby 1,2,3,10,11,12...) 
% Sprawdzam czy lewe, prawe czy oba i sprawdzam z grupą kontrolą,
% i liczę dokładność która ma być równa 1

%4) 36 prób - ilośc peaków na dominującym oku








