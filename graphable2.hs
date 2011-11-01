import Data.List
import qualified Data.Graph as G
data Node = Node { nodeValue :: String,
                   nodeNeighbors :: [Node]
                 } | None deriving (Show, Eq)

-- so a data type is of instance Graphable if it has mkGraph and that can be
-- used to get a graph representation from it

tfst (a, _, _) = a

safeHead [] = []
safeHead (x:xs) = x

class Graphable a where
    nodeEdges :: a -> [(a, String, [String])]
    nodeEdges x = [(x, (key x), (map key (neighbors x)))] ++ (safeHead $ (map nodeEdges (neighbors x)))
    mkGraph :: a -> (G.Graph, G.Vertex -> (a, String, [String]), String -> Maybe G.Vertex)
    mkGraph x = G.graphFromEdges (nodeEdges x)
    getGraph :: a -> G.Graph
    getGraph = tfst.mkGraph
    -- every node should have a unique key
    key :: a -> String
    neighbors :: a -> [a]


instance Graphable Node where
    key = nodeValue
    neighbors x = filter (/=None) $ nodeNeighbors x

sort :: Graphable a => a -> [G.Vertex]
sort = G.topSort . getGraph

n1 --> n2 = Node (nodeValue n1) ((nodeNeighbors n1) ++ [n2])

mkNodes xs = map (\x -> Node x [None]) xs
