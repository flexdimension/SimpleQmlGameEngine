'''
Created on 2012/11/01

@author: unseon_pro
'''
from PySide.QtCore import *
from PySide.QtGui import QMainWindow, QVBoxLayout, QColor

from PySide.QtDeclarative import QDeclarativeView
from GeoMap import GeoMap


class QmlGameFrame(QMainWindow):
    
    def __init__(self, parent = None) :
        '''
        Constructor
        '''
        super(QmlGameFrame, self).__init__(parent)
        
        layout = QVBoxLayout()
        
        self.view = QDeclarativeView(self)

        layout.addWidget(self.view)
        self.setLayout(layout)
                
        self.geoMap = GeoMap()
        #self.model.connect()
        
        #self.noteList = self.model.getNoteList()
        #self.noteList = self.model.getToDoList()
        
        
        
        rootContext = self.view.rootContext()
        rootContext.setContextProperty('geoMap', self.geoMap)
                
        path = QDir.currentPath() + '/../../qml/SimpleQmlGameEngine/main.qml'
        path = path.replace('users', 'Users')
        print path
        url = QUrl(path)
        #url = QUrl('file:///Users/unseon_pro/myworks/SimpleQmlGameEngine/qml/SimpleQmlGameEngine/main.qml')
        self.view.setSource(url)
