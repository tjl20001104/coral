from os import abort
from flask import Flask, request, g
from contextlib import closing
import config
import pymysql
import shutil
import base64
import numpy as np
from queue import PriorityQueue
import datetime

app = Flask(__name__)

'''
Written by 蔺祉潼 章龙飞
connect database
'''
def connect_db():
    return pymysql.connect(**config.DATABASE)

'''
Written by 蔺祉潼 章龙飞
help function for database
'''
def search_db(table, column, search_data, one=False):
    cursor = g.db.cursor()
    sql = 'select ' + column + ' from ' + str(table) + ' where '\
        + ' and '.join(search_data)    # connect each constraint to form a full command
    try:
        cursor.execute(sql)    
        results = cursor.fetchall()
        return (results[0] if results else None) if one else results   # return single dict, dict list, or None if not found
    except Exception as e:
        print(e)
        return None

'''
Written by 蔺祉潼 章龙飞
'''
def insert_db(table, insert_data):
    cursor = g.db.cursor()
    sql = 'insert into ' + str(table) + ' (' +\
          ','.join(insert_data.keys()) + \
          ') values (' + ','.join(insert_data.values()) + ')'
    try:
        cursor.execute(sql)
        g.db.commit()
    except Exception as e:
        print(e)
        g.db.rollback()
        raise Exception

'''
Written by 蔺祉潼 章龙飞
'''
def update_db(table, update_data, search_data):
    cursor = g.db.cursor()
    update_cond = []
    search_cond = []

    for key, value in update_data.items():
        update_cond.append(str(key) + " = " + str(value))
    for key, value in search_data.items():
        search_cond.append(str(key) + " = " + str(value))
    
    sql = 'update ' + str(table) + ' set '\
        + ' , '.join(update_cond) + ' where '\
        + ' and '.join(search_cond)
    try:
        cursor.execute(sql)
        g.db.commit()
    except Exception as e:
        print(e)
        g.db.rollback()
        raise Exception

'''
Written by 游克垚
connect database before request
close database after request
'''
@app.before_request
def before_request():
    g.db = connect_db()

@app.teardown_request
def teardown_request(exception):
    if hasattr(g, 'db'):
        g.db.close()

'''
Written by 蔺祉潼
login route
post: {
    'username': username,
    'password': password
}
response: {
    'userID': userID,
    'userName': userName,
    'sign': sign,
    'tags': tags,
    'mycorals': [
        {
            'coralID': coralID,
            'coralName': coralName,
            'coralPosition': coralPosition,
            'updateTime': updateTime,
            'light': light,
            'temp': temp,
            'microelement': microelement,
            'size': size,
            'lastmeasure': lastmeasure,
            'growth': growth,
            'score': score,
            'born_date': born date,
            'adopt_date': adopt date,
            'species': {
                'specieID': specieID,
                'species': species,
                'species_EN': species_EN,
                'tags': tags,
                'classification': classification,
                'classification_EN': classification_EN,
                'difficulty': difficulty,
                'growspeed': growspeed,
                'current': current,
                'light': light,
                'feed': feed,
                'color': color,
                'attention': attention,
            },
        },
        ...
    ],
    'success': True/False
}
'''
@app.route('/login',methods=["POST"])
def login():
    username = request.form['username']
    password = request.form['password']
    user = search_db('userinfo', '*', ['username=' + '\'' + username + '\''], one=True)

    if user and user['password'] == password:
        user['success'] = True
        corals = search_db('coralinfo', '*', ['masterID=' + str(user['userID'])])
        user['mycorals'] = []
        for coral in corals:
            species = search_db('species', '*', ['specieID=' + str(coral['speciesID'])], one=True)
            coral['species'] = species
            coral['updateTime'] = str(coral['updateTime'])
            coral['born_date'] = str(coral['born_date'])
            coral['adopt_date'] = str(coral['adopt_date'])
            user['mycorals'].append(coral)
    else:
        user = {}
        user['success'] = False
    return user

'''
Written by 蔺祉潼
signup route
post: {
    'username': username,
    'password': password
}
response: {
    'userID': userID,
    'userName': userName,
    'sign': sign,
    'tags': tags,
    'mycorals': [],
    'success': True/False
}
'''
@app.route('/signup',methods=["POST"])
def signup():
    username = request.form['username']
    password = request.form['password']
    user = search_db('userinfo', '*', ['username=' + '\'' + username + '\''], one=True)

    response = {}

    if user:
        response['success'] = False
        return response

    try:
        insert_db('userinfo', {'username': '\'' + username + '\'', 'password': '\'' + password + '\''})
        user = search_db('userinfo', '*', ['username=' + '\'' + username + '\''], one=True)
        shutil.copy("./static/user_avatar/default.jpg", "./static/user_avatar/" + str(user['userID']) + ".jpg")
        response = {
            'userID': user['userID'],
            'username': username,
            'sign': "无签名",
            'tags': "",
            'mycorals': [],
            'success': True,
        }
    except:
        response['success'] = False
    return response

'''
Written by 谈嘉乐 章龙飞
changeUserInfo route
post: {
    'userID': userID,
    'userName': userName,
    'sign': sign,
    'tags': tags,
    'avatar': avatar,
}
response: {
    'success': True/False
}
'''
@app.route('/changeUserInfo',methods=["POST"])
def changeUserInfo():
    userID = request.form['userID']
    userName = request.form['userName']
    sign = request.form['sign']
    tags = request.form['tags']
    avatar = request.form['avatar']

    response = {}

    try:
        if avatar != '':
            file = open("./static/user_avatar/" + str(userID) + ".jpg", 'wb')
            file.write(base64.b64decode(avatar))
            file.close()
        update_db('userinfo', {'userName': '\''+userName+'\'', 'sign': '\''+sign+'\'', 'tags': '\''+tags+'\''}, {'userID': userID})
        response['success'] = True
    except:
        response['success'] = False
    
    return response


'''
Written by 谈嘉乐
calculate the congruence(distance) between coral and user
'''
def get_tags_score(tags):
    tags = tags.split('-')
    tags_score = [0,0,0,0]
    if '大大咧咧' in tags:
        tags_score[0]=1
    elif '乐观' in tags:
        tags_score[0]=2
    elif '玻璃心' in tags:
        tags_score[0]=3
    else:
        tags_score[0]=np.random.randint(1,3,1)[0]
    if '内向' in tags:
        tags_score[1]=1
    elif '害羞' in tags:
        tags_score[1]=2
    elif '开朗' in tags:
        tags_score[1]=3
    elif '热情' in tags:
        tags_score[1]=4
    else:
        tags_score[1]=np.random.randint(1,4,1)[0]
    if '沉稳' in tags:
        tags_score[2]=1
    elif '冷静' in tags:
        tags_score[2]=2
    elif '好奇' in tags:
        tags_score[2]=3
    elif '勇敢' in tags:
        tags_score[2]=4
    else:
        tags_score[2]=np.random.randint(1,4,1)[0]
    if '聆听者' in tags:
        tags_score[3]=1
    elif '组织者' in tags:
        tags_score[3]=2
    elif '管理者' in tags:
        tags_score[3]=3
    else:
        tags_score[3]=np.random.randint(1,3,1)[0]
    return tags_score
def distance(user_tags, species_tags):
    dis = 0
    for i in range(4):
        dis = dis+(user_tags[i]-species_tags[i])*(user_tags[i]-species_tags[i])
    return dis

'''
Written by 谈嘉乐
match route
post: {
    'tags': tags
}
response: {
    'specieID': specieID,
    'species': species,
    'species_EN': species_EN,
    'tags': tags,
    'classification': classification,
    'classification_EN': classification_EN,
    'difficulty': difficulty,
    'growspeed': growspeed,
    'current': current,
    'light': light,
    'feed': feed,
    'color': color,
    'attention': attention,
}
'''
@app.route('/match',methods=["POST"])
def match():
    tags = request.form['tags']

    all = search_db('species', 'specieID, tags', ['remain>0'])

    if all:
        user_tags = get_tags_score(tags)
        q = PriorityQueue()
        for species in all:
            species_tags = get_tags_score(species['tags'])
            dis = (distance(user_tags, species_tags), species['specieID'])
            q.put(dis)
        specieID = q.get()[1]
        species = search_db('species', '*', ['specieID=' + str(specieID)], one=True)
        return species
    else:
        abort(404)

'''
Written by 谈嘉乐
box route
post: {
}
response: {
    'specieID': specieID,
    'species': species,
    'speciesen': species_EN,
    'tags': tags,
    'classification': classification,
    'classificationen': classification_EN,
    'difficulty': difficulty,
    'growspeed': growspeed,
    'current': current,
    'light': light,
    'feed': feed,
    'color': color,
    'attention': attention,
}
'''
@app.route('/box',methods=["POST"])
def box():
    all = search_db('species', 'specieID', ['remain>0'])

    if all:
        specieID = np.random.choice(all, 1)[0]['specieID']
        species = search_db('species', '*', ['specieID=' + str(specieID)], one=True)
        return species
    else:
        abort(404)

'''
Written by 谈嘉乐
listCorals route
post: {
    'specieID': specieID
}
response: {
    'result': [
        {
            'coralID': coralID,
            'coralName': coralName,
            'coralPosition': coralPosition,
            'updateTime': updateTime,
            'light': light,
            'temp': temp,
            'microelement': microelement,
            'size': size,
            'lastmeasure': lastmeasure,
            'growth': growth,
            'score': score,
            'born_date': born_date,
            'adopt_date': adopt_date,
            'species': species,
        },
        ...
    ]
}
'''
@app.route('/listCorals',methods=["POST"])
def listCorals():
    specieID = request.form['specieID']
    corals = search_db('coralinfo', '*', ['speciesID=' + str(specieID), 'masterID=-1'])
    for coral in corals:
        coral['updateTime'] = str(coral['updateTime'])
        coral['born_date'] = str(coral['born_date'])
        coral['adopt_date'] = str(coral['adopt_date'])
    return {'result': corals}

'''
Written by 谈嘉乐
adopt route
post: {
    'coralID': coralID
    'masterID': masterID,
    'coralName': coralName,
    'position': position,
}
response: {
    'adopt_date': adopt_date,
    'pos': [
        "凤凰岛西侧海域",
        "渤海东侧海域"
    ],
    'success': True/False
}
'''
@app.route('/adopt',methods=["POST"])
def adopt():
    coralID = request.form['coralID']
    masterID = request.form['masterID']
    coralName = request.form['coralName']
    position = request.form['position']

    response = {}

    try:
        coral = search_db('coralinfo', '*', ['coralID=' + str(coralID)], one=True)
        if coral['masterID'] == -1:
            remain = search_db('species', 'remain', ['specieID=' + str(coral['speciesID'])], one=True)['remain']
            update_db('species', {'remain': str(remain-1)}, {'specieID': coral['speciesID']})
        adopt_date = datetime.datetime.strftime(datetime.datetime.now(),'%Y-%m-%d %H:%M:%S')
        update_db('coralinfo', {'masterID': str(masterID), 'coralName': '\''+coralName+'\'', 'coralPosition': '\''+position+'\'', 'adopt_date': '\''+adopt_date+'\''}, {'coralID': coralID})
        response['adopt_date'] = adopt_date
        response['pos'] = [
            "凤凰岛西侧海域",
            "渤海东侧海域",
            "渤海西侧海域",
            "黄海东侧海域",
            "黄海西侧海域",
            "崇明岛西侧海域",
            "南海诸岛海域",
        ]
        response['success'] = True
    except:
        response['success'] = False
    
    return response

'''
Written by 章龙飞
getStory route
post: {
    'coralIDs': [...]
}
response: {
    'story': [
        {
            'coralID': coralID,
            'story': story,
            'image': image,
            'updateTime': updateTime,
        }
    ]
}
'''
@app.route('/getStory',methods=["POST"])
def getStory():
    coralIDs = request.form['coralIDs'].split('-')
    stories = []
    if coralIDs[0] != '':
        for i in coralIDs:
            stories += search_db('stories', '*', ['coralID=' + i])
    return {
        'story': stories
    }

# main
if __name__ == '__main__':
    app.config.from_object(config)
    app.run(host="0.0.0.0", port=config.PORT)