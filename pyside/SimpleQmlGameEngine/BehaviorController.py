'''
Created on 2012/11/07

@author: unseon_pro
'''
from PySide.QtCore import QObject, Signal, Slot, Property, QPoint, QAbstractListModel
from PySide import QtGui  
from PySide.QtDeclarative import QDeclarativeItem 

from DictListModel import DictListModel

class BehaviorController(QDeclarativeItem):
    '''
    classdocs
    '''

    pathChanged = Signal()
    
    def __init__(self, parent = None):
        QDeclarativeItem.__init__(self, parent)
        #self.movingPath = DictListModel([{"1": 2}])
        self.movingPath = [1, 2, 3]
    def getPath(self):
        return self.movingPath
    
    def setPath(self, p):
        self.movingPath = p
    
    @Slot(int, result = QPoint)
    def getAt(self, idx):
        return QPoint(2, 3)
            
    path = Property(list, getPath, setPath, notify = pathChanged)