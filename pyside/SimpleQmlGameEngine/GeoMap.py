'''
Created on 2012/11/01

@author: unseon_pro
'''
from PySide.QtCore import QObject, Slot, Signal, QAbstractListModel, QPoint
from DictListModel import DictListModel
from math import sqrt
from sys import float_info

class GeoMap(QObject):
    
    
    def __init__(self, authToken = "", parent = None):
        super(GeoMap, self).__init__(None)
        self.authToken = authToken
        self.width = 100
        self.height = 100
        
        self.geoMap = list({"geo":"ground"} for i in range(self.width * self.height))
    
        self.positions = []
        
    @Slot(result=int)
    def getWidth(self):
        return self.width
    
    @Slot(result=int)
    def getHeight(self):
        return self.height
    
    @Slot(int, int, result=str)
    def getGeo(self, x, y):
        return self.geoMap[y * self.width + x]["geo"]
    
    @Slot(int, int, str)
    def setGeo(self, x, y, geo):
        self.geoMap[y * self.width + x]["geo"] = geo
        
    def getModel(self):
        return DictListModel(self.geoMap)
    
    def getIndex(self, x, y):
        return self.width * y + x
    
    @Slot(int, result = QPoint)
    def getPathAt(self, idx):
        return QPoint(self.positions[idx]['x'], self.positions[idx]['y'])
    
    @Slot(result = int)
    def getPathSize(self):
        return len(self.positions)
        
    @Slot(int, int, int, int, result=bool)
    def findPath(self, sx, sy, tx, ty):
        def h(start, goal):
            return sqrt((goal[0] - start[0]) * (goal[0] - start[0]) + 
                    (goal[1] - start[1]) * (goal[1] - start[1]))
        
        def neighborNodes(posCurrent):
            rs = []
            
            x = posCurrent[0]
            y = posCurrent[1]
            
            if x > 0 and y > 0:
                rs.append((x - 1, y - 1 ))
            if y > 0:
                rs.append((x, y - 1 ))
            if x < self.width - 1 and y > 0:
                rs.append((x + 1, y - 1 ))
                
            if x > 0 :
                rs.append((x - 1, y))
            if x < self.width - 1:
                rs.append((x + 1, y))
                
            if x > 0 and y < self.height - 1:
                rs.append((x -1, y + 1))
            if y < self.height - 1:
                rs.append((x, y + 1))
            if x < self.width - 1 and y < self.height - 1:
                rs.append((x + 1, y + 1))
                
            return rs
        
        def reconstructPath(current):
            if current in cameFrom:
                p = reconstructPath(cameFrom[current])
                p.append(current)
                return p
            else:
                return [current]
            
        def distanceBetween(current, neighbor):
            if self.getGeo(neighbor[0], neighbor[1]) == "block":
                return float_info.max                
            else:
                cx = current[0]
                cy = current[1]
                
                nx = neighbor[0]
                ny = neighbor[1]
                
                dist = sqrt((cx - nx) * (cx - nx) + (cy - ny) * (cy - ny))
                
                if self.getGeo(neighbor[0], neighbor[1]) == "river":
                    dist *= 3
                    
                return dist 
           
        start = (sx / 5, sy / 5)
        goal = (tx / 5, ty / 5)
        closedSet = []
        openSet = [start]
        cameFrom =dict()
        
        gScore = dict()
        fScore = dict()
        gScore[start] = 0
        fScore[start] = gScore[start] + h(start, goal)
        
        while openSet :
            #openSet = sorted(openSet, key = lambda a: fScore[a])
            #current =  openSet[0]
            current = min(openSet, key = lambda a: fScore[a])
            if current == goal:
                path = reconstructPath(goal)
                self.positions = map((lambda p : {'x': p[0], 'y': p[1]}), path)
                return True
                #return 1234
            
            #openSet.pop(0)
            openSet.remove(current)
            closedSet.append(current)
            for neighbor in neighborNodes(current):
                if neighbor in closedSet:
                    continue
                
                tgScore = gScore[current] + distanceBetween(current, neighbor) #distance between cur and nbr
                
                if not neighbor in openSet or tgScore <= gScore[neighbor]:
                    cameFrom[neighbor] = current
                    gScore[neighbor] = tgScore
                    fScore[neighbor] = gScore[neighbor] + h(neighbor, goal)
                    if not neighbor in openSet:
                        openSet.append(neighbor)
        return False
    
        
    
    


        
    
        
        
        
        
        
        
        
    