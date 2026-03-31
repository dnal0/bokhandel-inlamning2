# Bokhandel Databas - Inlämning 2

Kurs: Databaser  
Datum: Mars 2026  

Hej! Här är min lösning för inlämning 2. Databasen bygger vidare på den bokhandel jag gjorde i inlämning 1, men nu har jag lagt till constraints, triggers, index, massor av testdata och allt som krävdes för de olika momenten. All kod ligger i `inlamning2.sql` och backup-filen heter `bokhandel_backup.sql`.

## Beskrivning av databasen

Databasen heter Bokhandel och är designad för en vanlig svensk bokhandel. Den hanterar:

- Kunder – namn, e-post, telefon och adress
- Böcker – ISBN, titel, författare, pris och lagersaldo
- Beställningar – kopplar kunder till ordrar med datum och totalsumma
- Orderrader – detaljer om vilka böcker som ingår i varje order (antal etc.)
- KundLogg – extra tabell för att logga när nya kunder registreras (används av trigger)

Jag har valt att hålla det normaliserat (3NF) så att vi slipper upprepningar och får bra integritet. Priset på böcker har en `CHECK`-constraint så det aldrig kan bli noll eller negativt. Foreign keys med `ON DELETE CASCADE` där det passar (t.ex. raderar orderrader om en order tas bort).

## Testdata

Jag har skapat kunder, 22 böcker och 8 beställningar (med orderrader) så att alla JOINs, GROUP BY och HAVING-frågor funkar fint. KundID 1 har till exempel fyra beställningar så vi kan testa `HAVING > 2`. Det finns också lite extra data för att trigga lagersaldo och loggningen.

All testdata ligger längst upp i `inlamning2.sql` och skriptet raderar + återskapar hela databasen varje gång så det alltid är rent när man kör det.

## Genomförda moment

Alla sex huvudmoment + reflektion är klara:

1. Testdata – minst 3 kunder, 3 böcker + flera ordrar 
2. Hämta, filtrera & sortera – SELECT med WHERE, LIKE, ORDER BY 
3. Modifiera data – UPDATE, DELETE + transaktioner med ROLLBACK 
4. JOINs & GROUP BY – INNER, LEFT, GROUP BY, HAVING 
5. Index, Constraints & Triggers – index på e-post, CHECK på pris, två triggers (logg + lagersaldo) 
6. Backup & Restore – backup-fil medföljer och jag har testat restore + kör frågor efteråt 

All kod är kommenterad och går att köra rakt av i MySQL/MariaDB.

## Reflektion

Jag valde den här designen för att den är enkel att förstå men ändå tillräckligt robust för en riktig bokhandel. Separata tabeller för orderrader gör det lätt att hantera flera böcker per order och triggarn som minskar lagret känns naturlig i en verklig miljö.


