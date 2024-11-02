# Adapted from: https://rosettacode.org/wiki/Zebra_puzzle#Nim

import std/[algorithm, sequtils]

type
  Nationality* = enum
    Englishman, Spaniard, Ukrainian, Japanese, Norwegian

  Color = enum
    Red, Green, Ivory, Yellow, Blue

  Pet = enum
    Dog, Snails, Fox, Horse, Zebra

  Drink = enum
    Coffee, Tea, Milk, OrangeJuice, Water

  Hobby = enum
    Dancing, Painting, Reading, Football, Chess

  House = object
    color: Color
    nationality: Nationality
    pet: Pet
    drink: Drink
    hobby: Hobby

  Solution = array[5, House]

iterator permutations[T]: array[5, T] =
  var term = [T(0), T(1), T(2), T(3), T(4)]
  yield term
  while term.nextPermutation():
    yield term

func init(T: typedesc[House], color: Color, nationality: Nationality, pet: Pet, drink: Drink, hobby: Hobby): T =
  T(color: color, nationality: nationality, pet: pet, drink: drink, hobby: hobby)

func solve: Solution =
  result = default(Solution)
  for colors in permutations[Color]():
    if colors.find(Ivory) != colors.find(Green) + 1: continue
    for nationalities in permutations[Nationality]():
      if nationalities[0] != Norwegian: continue
      if colors.find(Red) != nationalities.find(Englishman): continue
      if abs(nationalities.find(Norwegian) - colors.find(Blue)) != 1: continue
      for pets in permutations[Pet]():
        if nationalities.find(Spaniard) != pets.find(Dog): continue
        for drinks in permutations[Drink]():
          if drinks[2] != Milk: continue
          if nationalities.find(Ukrainian) != drinks.find(Tea): continue
          if colors.find(Green) != drinks.find(Coffee): continue
          for hobby in permutations[Hobby]():
            if hobby.find(Dancing) != pets.find(Snails): continue
            if hobby.find(Painting) != colors.find(Yellow): continue
            if hobby.find(Football) != drinks.find(OrangeJuice): continue
            if hobby.find(Chess) != nationalities.find(Japanese): continue
            if abs(hobby.find(Reading) - pets.find(Fox)) != 1: continue
            if abs(hobby.find(Painting) - pets.find(Horse)) != 1: continue
            for i in result.low..result.high:
              result[i] = House.init(colors[i], nationalities[i], pets[i], drinks[i], hobby[i])
            return result

# Calculate solution at compile time.
const solution = solve()

func waterDrunkBy*: Nationality =
  solution.filterIt(it.drink == Water)[0].nationality

func zebraOwnedBy*: Nationality =
  solution.filterIt(it.pet == Zebra)[0].nationality
