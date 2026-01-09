# ReadMe codice C Progetto Basi di Dati di un Sistema Informativo per la Gestione di Aste Online
Questo programma C serve per connettersi al database PostgreSQL e visualizzare a schermo i risultati delle query relative ad un sistema di aste online. 

## Requisiti
- GCC/compilatore C
- PostgreSQL
- LIbrerie necessarie: libpq-fe.h, pg_config_ext.h, postgres_ext, libpq.dll, libpq.lib (anche se non indicato per poterlo compilare è stato necessario anche libintl-9.dll)

## Compilazione
```powershell
gcc aste_online.c -I dependencies/include -L dependencies/lib -lpq -o aste
```

## Esecuzione
```powershell
./aste
```

Il programma richiede informazioni per connettersi al database, quali:
- Host address
- Porta
- Nome del database
- Nome utente
- Password di accesso

In questo caso:
``` C
#define PG_HOST "127.0.0.1"
#define PG_USER "postgres"
#define PG_DB "Aste_online"
#define PG_PASS "1234"
#define PG_PORT 5432
```

## Funzionalità
Una volta compilato ed eseguito il programma, verrà mostrato all’utente un menu con la seguente lista di interrogazioni disponibili:
 1. **Offerta massima per ogni asta “attiva”,  con il relativo cliente e l’oggettomin vendita**
 2. **Numero di offerte per asta per categoria scelta parametricamente:** richiede il nome di una categoria e mostra il numero di offerte per asta in quella categoria
 3. **Numero recensioni e punteggio medio per utente**
 4. **Clienti partecipanti almeno a N aste con N passato come parametro:** richiede un numero e mostra gli utenti che hanno partecipato ad almeno quel numero di aste
 5. **Oggetti con più di un’asta associata dopo una data passata come parametro:** richiede una data e mostra gli oggetti che hanno avuto più di un'asta dopo quella data

## Funzioni modulari
```do_exit(PGconn *conn)``` chiude la connessione in caso di errore
```checkResults(PGresult *res, const PGconn *conn)``` verifica la validità dei risultati
```printQuery(PGresult *res)``` stampa i risultati della query in formato tabellare con una grandezza fissa delle colonne

Inoltre per eseguire le query vengono usati ```PQexec``` o ```PQexecParams``` (nel caso di query paramatriche per gestire parametri dinamici).


