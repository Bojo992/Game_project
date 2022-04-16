function checkCollision(obj1, obj2, name1, name2) 
    return ((obj1.myName == name1 and obj2.myName == name2) or 
            (obj1.myName == name2 and obj2.myName == name1))
end