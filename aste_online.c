#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libpq-fe.h>

#define PG_HOST "127.0.0.1" //hostaddr
#define PG_USER "postgres" //username
#define PG_DB "Aste_online" //database nome
#define PG_PASS "1234" 
#define PG_PORT 5432

// funzione che chiude la connessione e termina il programma in caso di errore
void do_exit(PGconn *conn) {   
    PQfinish(conn);
    exit(1);
}

// funzione che controlla la consistenza del risultato
void checkResults(PGresult *res, const PGconn *conn) {
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        printf("Risultati inconsistenti %s\n", PQerrorMessage(conn));
        PQclear(res);
        exit(1);
    }
}

// funzione che stampa a schermo i risultati della query richiesta
void printQuery(PGresult *res){
    // Trovo il numero di tuple e campi selezionati
    int numTuple = PQntuples(res);
    int campi = PQnfields(res);
    

    // Stampo le intestazioni delle colonne

    for (int i = 0; i < campi; i++) {
        //printf("%s\t\t", PQfname(res, i));
        printf("%-25s", PQfname(res, i)); 
    }
    printf("\n");
    
    // Stampo i valori selezionati
    for (int i = 0; i < numTuple; i++) {
        for (int j = 0; j < campi; j++) {
            //printf("%s\t\t", PQgetvalue(res, i, j));
            printf("%-25s", PQgetvalue(res, i, j));
        }
        printf("\n");
    }  
    printf("\n");
    PQclear(res); // elimina il risultato dalla memoria
}

int main(int argc, char **argv) {   
    printf("Programma avviato...\n"); 

    char conninfo[250];
    sprintf(conninfo, "user=%s password=%s dbname=%s hostaddr=%s port=%d", PG_USER, PG_PASS, PG_DB, PG_HOST, PG_PORT);

    PGconn *conn = PQconnectdb(conninfo); //Connessione al database --> funzione PQconnectdb apre la connessione con il database a partire da un stringa di parametri
    // sistema di controllo per lo stato della connessione
    if (PQstatus(conn) == CONNECTION_BAD) { //Se non è possibile connettersi -->  PQstatus(conn) restituisce lo stato della connessione tramite due costanti: CONNECTION_OK e CONNECTION_BAD
        printf("Connection to database failed: %s\n", PQerrorMessage(conn)); // restituisce l’ultimo messaggio di errore generato    
        do_exit(conn);
    }

    else{
        printf("Connessione avvenuta correttamente...\n\n");
    }

    int opzione;
    printf("Menu\' query disponibili:\n"
           " 1) Offerta massima per ogni asta \'attiva\'\n"
           " 2) Numero di clienti distinti per categoria\n"
           " 3) Numero recensioni e punteggio medio per utente\n"
           " 4) Clienti partecipanti almeno a due aste\n"
           " 5) Oggetti con piu\' di un\'asta associata\n\n"
           "Seleziona una query digitando da 1 a 5: ");
    scanf("%d", &opzione);


    switch (opzione) {
    // query 1
        case 1: {
            PGresult *res_query_1 = PQexec(conn, 
                "SELECT a.ID_asta, o.Titolo AS Oggetto, of.ID_offerta, c.Nome, c.Cognome, of.Importo "
                "FROM Asta a "
                "JOIN Oggetto o ON a.Oggetto = o.Titolo "
                "JOIN Offerta of ON a.ID_asta = of.Asta "
                "JOIN Cliente c ON of.Cliente = c.ID_cliente "
                "WHERE a.Stato_asta = 'attiva' "
                "AND of.Importo = ( "
                "    SELECT MAX(Importo) "
                "    FROM Offerta "
                "    WHERE Asta = a.ID_asta) "
                "ORDER BY a.ID_asta;");  //Esegui una query sulla connessione 

            checkResults(res_query_1, conn); // verifica lo stato dei risultati per assicurarsi che non si siano verificati errori

            printf("\n- QUERY 1 -\n");
            printQuery(res_query_1);
            break;
        }

    // query 2
        case 2: {
            char nome_categoria[100];
            printf("Inserire nome categorie:  ");
            scanf("%s", nome_categoria);
            printf("\n");

            const char *parametro2[1] = {nome_categoria};
            PGresult *res_query_2 = PQexecParams(conn, 
                "SELECT a.ID_asta, COUNT(of.ID_offerta) AS Numero_offerte "
                "FROM Categoria cat "
                "JOIN Oggetto o ON cat.Nome_categoria = o.Categoria "
                "JOIN Asta a ON o.Titolo = a.Oggetto "
                "JOIN Offerta of ON a.ID_asta = of.Asta "
                "WHERE cat.Nome_categoria = $1 "
                "GROUP BY a.ID_asta "
                "ORDER BY a.ID_asta;", 1, NULL, parametro2, NULL, NULL, 0);  //Esegui una query sulla connessione 
        
            checkResults(res_query_2, conn);
            
            printf("\n- QUERY 2 -\n");
            printQuery(res_query_2);
            break;
        }

    // query 3
        case 3: {
            PGresult *res_query_3 = PQexec(conn, 
                "SELECT u.ID_utente, COUNT(r.ID_recensione) AS Numero_recensioni_fatte, "
                "ROUND(AVG(r.Punteggio), 3)  AS Punteggio_medio_dato "
                "FROM Utente u "
                "JOIN Recensione r ON u.ID_utente = r.Autore "
                "GROUP BY u.ID_utente;");  //Esegui una query sulla connessione 
        
            checkResults(res_query_3, conn);
            
            printf("\n- QUERY 3 -\n");
            printQuery(res_query_3);
            break;
        }
    
    // query 4
        case 4: {
            int num_aste;
            printf("Inserire numero aste a cui il cliente deve aver partecipato:  ");
            scanf("%d", &num_aste);
            printf("\n");

            // Conversione del parametro da int a stringa
            char num_aste_str[10];
            sprintf(num_aste_str, "%d", num_aste);

            const char *parametro4[1];
            parametro4[0] = num_aste_str;

            PGresult *res_query_4 = PQexecParams(conn, 
                "SELECT u.ID_utente, COUNT(DISTINCT p.Asta) AS Numero_aste "
                "FROM Partecipazione p "
                "JOIN Utente u ON p.Utente = u.ID_utente "
                "GROUP BY u.ID_utente "
                "HAVING COUNT(DISTINCT p.Asta) >= $1;", 1, NULL, parametro4, NULL, NULL, 0);  //Esegui una query sulla connessione 
        
            checkResults(res_query_4, conn);
            int numTuple4 = PQntuples(res_query_4);

            printf("\n- QUERY 4 -\n");
            printQuery(res_query_4);
            break;
        }
    
    // query 5
        case 5: {
            char data[11]; 
            printf("Inserisci la data (formato YYYY-MM-DD): ");
            scanf("%s", data);
            printf("\n");

            const char *parametro5[1] = {data};

            PGresult *res_query_5 = PQexecParams(conn, 
                "SELECT o.Titolo, COUNT(a.ID_asta) AS Numero_aste "
                "FROM Oggetto o "
                "JOIN Asta a ON o.Titolo = a.Oggetto "
                "WHERE a.Data_inizio > $1 "
                "GROUP BY o.Titolo "
                "HAVING COUNT(a.ID_asta) > 1;", 1, NULL, parametro5, NULL, NULL, 0);  //Esegui una query sulla connessione 
        
            checkResults(res_query_5, conn);
            
            printf("\n- QUERY 5 -\n");
            printQuery(res_query_5);
            break;
        }

    // inserimento numero sbagliato oltre 1-5    
        default:
            printf("Opzione non valida, selezionare un numero tra 1 e 5!\n");
        break;
    }
    
    PQfinish(conn); // chiude la connessione col DB
    
    return 0;
}