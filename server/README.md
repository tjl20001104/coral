# Server for project

## Requirement
- MySQL
- Flask

## Static Files
- coral_avatar  // 珊瑚头像
    - 1.jpg // coralID.jpg
    - 2.jpg
    ...
    - default.jpg // 默认头像
- coral_bg      // 珊瑚背景
    - 1 // coralID
        - 1.jpg // 三张背景
        - 2.jpg
        - 3.jpg
    - 2
        - 1.jpg
        - 2.jpg
        - 3.jpg
    ...
- coral_intro   // 珊瑚介绍
    - acropora.jpg
- daily         // 每日精选
    - 1.jpg
    - 2.jpg
    - 3.jpg
- storys        // 珊瑚故事
    - 1 // coralID
        - 1.jpg // 三张背景
        - 2.jpg
        - 3.jpg
    - 2
        - 1.jpg
        - 2.jpg
        - 3.jpg
    ...
    - default.jpg
- user_avatar   // 用户头像
    - 1.jpg // userID.jpg
    - 2.jpg
    ...
    - default.jpg // 默认头像

## Route
- /login 判断用户名和密码是否正确
    - post
    ```
    {
        'username': string,
        'password': string
    }
    ```
    - response
    ```
    正确
    {
        'userID': int,
        'userName': string,
        'sign': string,
        'tags': string, // 外向开朗-热情-心思细腻
        'mycorals': [   // 所有拥有珊瑚信息
            {
                'coralID': int,
                'coralName': string,
                'coralPosition': string,
                'updateTime': string, // 2021.1.2
                'light': string, // 充足
                'temp': string, // 温暖
                'microelement': string, // 偏少
                'size': int, // cm
                'lastmeasure': float, // cm
                'growth': float, // cm
                'score': int,
                'born_date': string, // 2021.1.2
                'adopt_date': string, // 2021.1.2
                'species': {    //珊瑚种类信息
                    'specieID': int,
                    'species': string,
                    'species_EN': string,
                    'tags': string, // 好强-敏感
                    'classification': string, // 大类
                    'classification_EN': string,
                    'difficulty': int, // 1~5
                    'growspeed': string, // 快
                    'current': string, // 中弱
                    'light': string, // 中等
                    'feed': string, // 低
                    'color': string, // FFFFFF-FBFCBB
                    'attention': string, // 易碎-毒性强
                },
            },
            ...
        ],
        'success': True
    }
    错误
    {
        'success': False
    }
    ```
- /signup 根据用户名和密码进行注册
    - post
    ```
    {
        'username': username,
        'password': password
    }
    ```
    - response
    ```
    成功
    {
        'userID': userID,
        'userName': userName,
        'sign': sign,
        'tags': tags,
        'mycorals': [],
        'success': True
    }
    失败
    {
        'success': False
    }
    ```
- /changeUserInfo 更改用户信息
    - post
    ```
    {
        'userID': userID,
        'userName': userName,
        'sign': sign,
        'tags': tags,
        'avatar': avatar, // base64编码字节流图片
    }
    ```
    - response
    ```
    成功
    {
        'success': True
    }
    失败
    {
        'success': True
    }
    ```
- /match 匹配 返回珊瑚种类
    - post
    ```
    {
        'tags': tags
    }
    ```
    - response
    ```
    {
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
    ```
- /box 盲盒 返回珊瑚种类
    - post
    ```
    {
    }
    ```
    - response
    ```
    {
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
    ```
- /listCorals 返回指定种类的所有珊瑚
    - post
    ```
    {
        'species': species
    }
    ```
    - response
    ```
    {
        'result': [
            {
                'coralID': coralID,
                'coralName': coralName,
                'coralPosition': string,
                'updateTime': updateTime,
                'light': light,
                'temp': temp,
                'microelement': microelement,
                'size': size,
                'lastmeasure': lastmeasure,
                'growth': growth,
                'score': score,
                'birth_date_': birth_date,
                'adopt_date': adopt_date,
                'species': species,
            },
            ...
        ]
    }
    ```
- /adopt 领养珊瑚，更改珊瑚对应信息
    - post
    ```
    {
        'coralID': coralID
        'masterID': masterID,
        'coralName': coralName,
        'position': position,
    }
    ```
    - response
    ```
    成功
    {
        'adopt_date': adopt_date,
        'pos': [
            "凤凰岛西侧海域",
            "渤海东侧海域"
        ],
        'success': True
    }
    失败
    {
        'success': False
    }
    ```
- /getStory 根据珊瑚ID返回珊瑚故事
    - post
    ```
    {
        'coralIDs': [1， 2...]
    }
    ```
    - response
    ```
    {
        'story': [
            {
                'coralID': coralID,
                'story': story,
                'image': image,
                'updateTime': updateTime,
            },
            ...
        ]
    }
    ```