'''
Created on 2012/11/06

@author: unseon_pro
'''
'''
Created on 2012/11/01

@author: unseon_pro
'''
import sys
from PySide.QtCore import *
from PySide.QtGui import QApplication, QWidget
from PySide import QtDeclarative

from QmlGameFrame import QmlGameFrame
from BehaviorController import BehaviorController
 
QtDeclarative.qmlRegisterType(BehaviorController, "engine", 1, 0, "BehaviorController")
# Create Qt application and the QDeclarative view
app = QApplication(sys.argv)
view = QmlGameFrame()
view.resize(400, 500)


view.show()


# Enter Qt main loop
sys.exit(app.exec_())