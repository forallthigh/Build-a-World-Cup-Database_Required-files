#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

FILE_NAME='games.csv'
cat $FILE_NAME | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
        #TEST echo "$YEAR '\' $ROUND '\' $WINNER '\' $OPPONENT '\' $WINNER_GOALS '\' $OPPONENT_GOALS"

#insert data from games to teams table

#ignore the first line
  if [[ $YEAR != 'year' ]]
  then
#get winner id
  WINNER_NAME_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$WINNER'")
    #if not found
    if [[ -z $WINNER_NAME_ID ]]
      then
        #insert new value
        INSERT_WINNER_RESULT=$($PSQL"INSERT INTO teams(name) VALUES ('$WINNER')")

        #if inserted success
        if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]]
        then echo "inserted >> $WINNER successfully!"
        else echo "insert error: $INSERT_WINNER_RESULT"
        fi
        #get winner id again
        WINNER_NAME_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
  echo "team: $WINNER has id: $WINNER_NAME_ID" #TEST

#get opponent id
  OPPONENT_NAME_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #if not found
    if [[ -z $OPPONENT_NAME_ID ]]
      then
        #insert new value
        INSERT_OPPONENT_RESULT=$($PSQL"INSERT INTO teams(name) VALUES ('$OPPONENT')")

        #if inserted success
        if [[ $INSERT_OPPONENT_RESULT == 'INSERT 0 1' ]]
        then echo "inserted >> $OPPONENT successfully!"
        else echo "insert error: $INSERT_OPPONENT_RESULT"
        fi
        #get opponent id again
        OPPONENT_NAME_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
  echo "team: $OPPONENT has id: $OPPONENT_NAME_ID" #TEST

#insert game info / year,round,winner,opponent,winner_goals,opponent_goals
  GAME_INFO_INSERT_RESULT=$($PSQL"INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals ) VALUES($YEAR, '$ROUND', $WINNER_NAME_ID, $OPPONENT_NAME_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  echo "$GAME_INFO_INSERT_RESULT"
fi
done