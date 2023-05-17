-- 2021/2022 autumn
-- This was a final project for the course, where we had to implement some basic functions of the Plants vs Zombies video game.
-- I gained a deeper understanding of the Haskell language and functional programming in general.

-- 2022/2023 ősz
-- Ez egy év végi beadandó feladat volt, a Plants vs Zombies videójáték pár alap funkcióját kellett megvalósítani.
-- A feladatban mélyebb tapasztalatot szereztem a Haskell nyelvvel, és a funkcionális programozással kapcsolatban.

module Pvz where

import Data.List
import Data.Maybe
import Data.Tuple

type Coordinate = (Int, Int)

type Sun = Int

data Plant = Peashooter Int | Sunflower Int | Walnut Int | CherryBomb Int deriving (Eq, Show)

data Zombie = Basic Int Int | Conehead Int Int | Buckethead Int Int | Vaulting Int Int deriving (Eq, Show)

data GameModel = GameModel Sun [(Coordinate, Plant)] [(Coordinate, Zombie)] deriving (Eq, Show)

defaultPeashooter :: Plant
defaultPeashooter = Peashooter 3

defaultSunflower :: Plant
defaultSunflower = Sunflower 2

defaultWalnut :: Plant
defaultWalnut = Walnut 15

defaultCherryBomb :: Plant
defaultCherryBomb = CherryBomb 2

basic :: Zombie
basic = Basic 5 1

coneHead :: Zombie
coneHead = Conehead 10 1

bucketHead :: Zombie
bucketHead = Buckethead 20 1

vaulting :: Zombie
vaulting = Vaulting 7 2

prices :: [(Plant, Int)]
prices = [(defaultPeashooter, 100), (defaultSunflower, 50), (defaultWalnut, 50), (defaultCherryBomb, 150)]

bounds :: [Coordinate]
bounds = [(x, y) | x <- [0 .. 4], y <- [0 .. 11]]

tryPurchase :: GameModel -> Coordinate -> Plant -> Maybe GameModel
tryPurchase (GameModel sun plants zombies) coords plant
  | lookup coords plants /= Nothing = Nothing
  | elem coords bounds == False = Nothing
  | lookup plant prices > Just sun = Nothing
  | otherwise = Just (GameModel (sun - fromJust (lookup plant prices)) ((coords, plant) : plants) zombies)

placeZombieInLane :: GameModel -> Zombie -> Int -> Maybe GameModel
placeZombieInLane (GameModel sun plants zombies) zombie lane
  | elem lane (map fst bounds) == False = Nothing
  | (elem lane $ map fst (map fst zombies)) && (lookup lane (map fst zombies) == Just 11) = Nothing
  | otherwise = Just (GameModel sun plants (((lane, 11), zombie) : zombies))

dec :: Int -> Int
dec x = x - 1

performZombieActions :: GameModel -> Maybe GameModel
performZombieActions (GameModel sun plants zombies)
  | finished (map fst zombies) = Nothing
  | otherwise = Just (GameModel sun (map changePlants plants) (map changeZombies zombies))
  where
    finished :: [Coordinate] -> Bool
    finished xs
      | lookup 0 (map swap xs) /= Nothing = True
      | otherwise = False

    changePlants :: (Coordinate, Plant) -> (Coordinate, Plant)
    changePlants (coords, plant) = (coords, last (take (length [c | (c, z) <- zombies, c == coords, z /= vaulting] + 1) (iterate dmgPlant plant)))

    dmgPlant :: Plant -> Plant
    dmgPlant (Peashooter hp) = (Peashooter (dec hp))
    dmgPlant (Sunflower hp) = (Sunflower (dec hp))
    dmgPlant (CherryBomb hp) = (CherryBomb (dec hp))
    dmgPlant (Walnut hp) = (Walnut (dec hp))

    changeZombies :: (Coordinate, Zombie) -> (Coordinate, Zombie)
    changeZombies (coords, zombie)
      | zombie == vaulting = handleVaulting (coords, zombie)
      | otherwise = if elem coords (map fst plants) then (coords, zombie) else step (coords, zombie)

    step :: (Coordinate, Zombie) -> (Coordinate, Zombie)
    step (coords, zombie) = ((fst coords, dec (snd coords)), zombie)

    handleVaulting :: (Coordinate, Zombie) -> (Coordinate, Zombie)
    handleVaulting (coords, (Vaulting hp 2))
      | elem (fst coords, (snd coords) - 1) (map fst plants) = ((fst coords, (snd coords) - 2), (Vaulting hp 1))
      | elem coords (map fst plants) = ((fst coords, (snd coords) - 1), (Vaulting hp 1))
      | otherwise = ((fst coords, (snd coords) - 2), vaulting)

cleanBoard :: GameModel -> GameModel
cleanBoard (GameModel sun plants zombies) = (GameModel sun [plant | plant <- plants, deadPlant plant == False] [zombie | zombie <- zombies, deadZombie zombie == False])
  where
    deadPlant :: (Coordinate, Plant) -> Bool
    deadPlant (_, (Peashooter hp)) = hp <= 0
    deadPlant (_, (Sunflower hp)) = hp <= 0
    deadPlant (_, (CherryBomb hp)) = hp <= 0
    deadPlant (_, (Walnut hp)) = hp <= 0

    deadZombie :: (Coordinate, Zombie) -> Bool
    deadZombie (_, Basic hp _) = hp <= 0
    deadZombie (_, Buckethead hp _) = hp <= 0
    deadZombie (_, Conehead hp _) = hp <= 0
    deadZombie (_, Vaulting hp _) = hp <= 0

performPlantActions :: GameModel -> GameModel
performPlantActions (GameModel sun plants zombies) = cherrybombAction $ sunflowerAction $ peashooterAction (GameModel sun plants zombies)
  where
    peashooterAction :: GameModel -> GameModel
    peashooterAction (GameModel sun plants zombies) = (GameModel sun plants (map shootZombies zombies))
      where
        shootZombies :: (Coordinate, Zombie) -> (Coordinate, Zombie)
        shootZombies (coords, zombie)
          | elem coords targetZombies = (coords, last (take (peashootersInRow coords + 1) (iterate dmgZombie zombie)))
          | otherwise = (coords, zombie)

        peashootersInRow :: Coordinate -> Int
        peashootersInRow coords = length [p | ((x, y), p) <- plants, isPeashooter p, x == fst coords]

        dmgZombie :: Zombie -> Zombie
        dmgZombie (Basic hp speed) = (Basic (dec hp) speed)
        dmgZombie (Buckethead hp speed) = (Buckethead (dec hp) speed)
        dmgZombie (Conehead hp speed) = (Conehead (dec hp) speed)
        dmgZombie (Vaulting hp speed) = (Vaulting (dec hp) speed)

        isPeashooter :: Plant -> Bool
        isPeashooter (Peashooter hp) = True
        isPeashooter _ = False

        rowsWithPeashooters :: [Int]
        rowsWithPeashooters = [x | ((x, y), p) <- plants, isPeashooter p]

        targetZombies :: [Coordinate]
        targetZombies = concatMap (take 1) $ groupBy (\(a, _) (b, _) -> a == b) $ sort [coords | (coords, zombie) <- zombies, elem (fst coords) rowsWithPeashooters]

    sunflowerAction :: GameModel -> GameModel
    sunflowerAction (GameModel sun plants zombies) = (GameModel (sun + ((sunflowerCount plants) * 25)) plants zombies)
      where
        sunflowerCount :: [(Coordinate, Plant)] -> Int
        sunflowerCount [] = 0
        sunflowerCount (p : ps)
          | isSunflower (snd p) = 1 + sunflowerCount ps
          | otherwise = sunflowerCount ps

        isSunflower :: Plant -> Bool
        isSunflower (Sunflower hp) = True
        isSunflower _ = False

    cherrybombAction :: GameModel -> GameModel
    cherrybombAction (GameModel sun plants zombies) = (GameModel sun (map activateCherries plants) (map killZombies zombies))
      where
        activateCherries :: (Coordinate, Plant) -> (Coordinate, Plant)
        activateCherries (coords, plant)
          | isCherry plant = (coords, (CherryBomb 0))
          | otherwise = (coords, plant)

        killZombies :: (Coordinate, Zombie) -> (Coordinate, Zombie)
        killZombies (coords, zombie)
          | elem coords blastedFields = (coords, killZombie zombie)
          | otherwise = (coords, zombie)

        killZombie :: Zombie -> Zombie
        killZombie (Basic _ speed) = (Basic 0 speed)
        killZombie (Buckethead _ speed) = (Buckethead 0 speed)
        killZombie (Conehead _ speed) = (Conehead 0 speed)
        killZombie (Vaulting _ speed) = (Vaulting 0 speed)

        isCherry :: Plant -> Bool
        isCherry (CherryBomb hp) = True
        isCherry _ = False

        killZone :: Coordinate -> [Coordinate]
        killZone coords = [(x, y) | x <- [(fst coords) - 1 .. (fst coords) + 1], y <- [(snd coords) - 1 .. (snd coords) + 1], x >= 0, y >= 0, elem (x, y) bounds]

        blastedFields :: [Coordinate]
        blastedFields = concat [killZone (fst plant) | plant <- plants, isCherry (snd plant)]