import Data.List
data Node = Node { value :: String,
                   neighbors :: [Node],
                   parent :: Node
                 } | None

instance Eq Node where
    (Node _ _ _) == None = False
    None == (Node _ _ _) = False
    None == None = True
    (Node v1 n1 p1) == (Node v2 n2 p2) = v1 == v2

get_value (Node v _ _) = v
get_value None = "_"

instance Show Node where
    show (Node v n p) = v ++ " -> (" ++ (unwords $ map get_value n) ++ ")"
    show None = "_"

-- get all ancestors of a node in order of oldest -> parent
ancestors (Node _ _ None) = []
ancestors (Node _ _ ancestor) = (ancestors ancestor) ++ [ancestor]

_path [] _ _ = Nothing

_path queue end seen =
    if any (==end) _neighbors then
       Just $ (ancestors start) ++ [start, end]
       else
       _path ((tail queue) ++ (filter (`notElem` seen) _neighbors)) end (seen ++ _neighbors)
    where
        start = queue !! 0
        _neighbors = neighbors start

-- Given a start and an end, find the path from start to end through a series of associations
-- This uses BFS, which as we will see ends up being not great.
path start end
    | start == end = (Just [start])
    | otherwise = _path [start] end [start]

b = Node "b" [None] a
a = Node "a" [b] None

{-
make mat = map (\(i, j) -> if ((mat !! i) !! j) == 1 then update_nodes_with_new_connection else whatever)  indexes
    where
        nodes = take (genericLength mat) $ repeat (Node "_" [None] None)
        ind = indexes mat

indexes mat = [(i, j) | i <- [0..((genericLength mat)-1)], j <- [0..((genericLength $ head mat)-1)]]
-}

main = do
    putStrLn $ show $ path a b
