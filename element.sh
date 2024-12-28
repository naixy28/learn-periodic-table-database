#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
check_input() {
  if [[ -n $1 ]]
  then 
    INPUT="$1"

    if [[ $INPUT =~ ^[0-9]+$ ]]
    then
    # number
      RESULT=$($PSQL "select elements.atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements left join properties on elements.atomic_number=properties.atomic_number left join types on properties.type_id=types.type_id where elements.atomic_number=$INPUT::integer")
    else
    # string
      RESULT=$($PSQL "select elements.atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements left join properties on elements.atomic_number=properties.atomic_number left join types on properties.type_id=types.type_id where elements.symbol ilike '$INPUT' or elements.name ilike '$INPUT'")
    fi

    if [[ -n $RESULT ]]
    then
      output_res "$RESULT"
    else
      echo -e "I could not find that element in the database."
    fi

  else
    echo -e "Please provide an element as an argument."
  fi
}
output_res() {
  RESULT=$1
  echo $RESULT | while IFS="|" read AT_NUMBER SYMBOL NAME TYPE AT_MASS MP BP
  do
  echo -e "The element with atomic number $AT_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AT_MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
  done
}
check_input "$@"

# The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.

# select elements.atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements left join properties on elements.atomic_number=properties.atomic_number left join types on properties.type_id=types.type_id;
