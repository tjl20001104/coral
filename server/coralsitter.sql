SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for coralinfo
-- ----------------------------
DROP TABLE IF EXISTS `coralinfo`;
CREATE TABLE `coralinfo`  (
  `coralID` int NOT NULL AUTO_INCREMENT,
  `coralName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `coralPosition` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `updateTime` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `score` int NOT NULL DEFAULT 0,
  `growth` float NOT NULL DEFAULT 0,
  `lastmeasure` float NULL DEFAULT NULL,
  `size` int NOT NULL DEFAULT 0,
  `speciesID` int NULL DEFAULT NULL,
  `masterID` int NULL DEFAULT -1,
  `temp` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '未知',
  `microelement` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '未知',
  `light` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '未知',
  `born_date` datetime NULL DEFAULT NULL,
  `adopt_date` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`coralID`) USING BTREE,
  INDEX `species_coral`(`speciesID`) USING BTREE,
  INDEX `masterID`(`masterID`) USING BTREE,
  CONSTRAINT `masterID` FOREIGN KEY (`masterID`) REFERENCES `userinfo` (`userID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `species_coral` FOREIGN KEY (`speciesID`) REFERENCES `species` (`specieID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of coralinfo
-- ----------------------------
INSERT INTO `coralinfo` VALUES (1, '泡泡', '凤凰岛西侧海域', '2021-12-26 14:33:30', 90, 0.15, 0.1, 14, 1, 1, '温暖', '正常', '充足', '2020-12-26 14:33:30', '2021-12-26 14:33:30');

INSERT INTO `coralinfo` VALUES (2, '', '渤海东侧海域', '2021-12-26 14:33:31', 87, 0.12, 0.2, 12, 1, -1, '温暖', '偏少', '充足', '2020-9-26 14:33:30', NULL);

INSERT INTO `coralinfo` VALUES (3, '', '黄海东侧海域', '2021-12-26 14:33:31', 85, 0.14, 0.2, 13, 2, -1, '温暖', '正常', '较弱', '2020-5-26 14:33:30', NULL);

INSERT INTO `coralinfo` VALUES (4, '', '崇明岛西侧海域', '2021-12-26 14:33:31', 89, 0.16, 0.1, 11, 3, -1, '较冷', '正常', '充足', '2020-7-26 14:33:30', NULL);

INSERT INTO `coralinfo` VALUES (5, '', '南海诸岛海域', '2021-12-26 14:33:31', 83, 0.13, 0.16, 9, 4, -1, '温暖', '充足', '充足', '2020-1-26 14:33:30', NULL);

INSERT INTO `coralinfo` VALUES (6, '', '黄海西侧海域', '2021-12-26 14:33:31', 85, 0.14, 0.2, 13, 5, -1, '温暖', '正常', '较弱', '2020-5-26 14:33:30', NULL);

-- ----------------------------
-- Table structure for species
-- ----------------------------
DROP TABLE IF EXISTS `species`;
CREATE TABLE `species`  (
  `specieID` int NOT NULL AUTO_INCREMENT,
  `species` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '未知',
  `species_EN` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '未知',
  `classification` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '未知',
  `classification_EN` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '未知',
  `difficulty` int NULL DEFAULT 0 COMMENT '0-5',
  `growspeed` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `current` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '未知',
  `light` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '未知',
  `feed` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '未知',
  `color` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '未知',
  `attention` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '无',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '无',
  `remain` int NULL DEFAULT 0 COMMENT '该种类下剩余珊瑚数量\r\n',
  PRIMARY KEY (`specieID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of species
-- ----------------------------
INSERT INTO `species` VALUES (1, '气泡珊瑚', 'Plerogyra sinuosa', '大水螅体硬珊瑚', 'LPS Hard Corals', 2, '快', '中弱', '中等', '低', 'FFFFFF-FBFCBB', '易碎-毒性强', '大大咧咧-内向-沉稳-聆听者', 1);

INSERT INTO `species` VALUES (2, '鹿角珊瑚', 'Acropora Coral', '小水螅体硬珊瑚', 'SPS Hard Corals', 4, '快', '中强', '中强', '中', 'FFFFFF-FBFABB', '易碎-毒性强', '乐观-害羞-冷静-组织者', 1);

INSERT INTO `species` VALUES (3, '牛眼菇', 'Bullseye Mushroom', '菇珊瑚', 'Mushroom Coral', 2, '快', '较弱', '中弱', '中', 'FFFFFF-FBFACB', '攻击性-毒性强', '玻璃心-热情-勇敢-管理者', 1);

INSERT INTO `species` VALUES (4, '太平洋玫瑰珊瑚', 'Pacific rose coral', '大水螅体硬珊瑚', 'LPS Hard Corals', 5, '快', '较弱', '中弱', '中', 'FFFFFF-FBFACB', '贪吃-攻击性', '大大咧咧-热情-勇敢-组织者', 1);

INSERT INTO `species` VALUES (5, '束型真叶珊瑚', 'Torch coral', '真叶珊瑚', 'Euphyllia ancora', 4, '快', '中弱', '中', '中', 'FFFFFF-FBFACB', '易碎-尖锐-攻击性', '玻璃心-害羞-勇敢-组织者', 1);

-- ----------------------------
-- Table structure for stories
-- ----------------------------
DROP TABLE IF EXISTS `stories`;
CREATE TABLE `stories`  (
  `coralID` int NOT NULL,
  `story` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `updateTime` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`coralID`) USING BTREE,
  CONSTRAINT `coralID` FOREIGN KEY (`coralID`) REFERENCES `coralinfo` (`coralID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of stories
-- ----------------------------
INSERT INTO `stories` VALUES (1, '小丑鱼拜访了我', '2021_12_26.jpg', '2021-12-26 14:53:53');

INSERT INTO `stories` VALUES (2, '今天吃的好饱！', '2021_7_13.jpg', '2021-7-13 11:56:51');

INSERT INTO `stories` VALUES (3, '我有新伙伴啦！', '2021_3_26.jpg', '2021-3-26 19:27:46');

INSERT INTO `stories` VALUES (4, '又是健康成长的一天！', '2021_9_16.jpg', '2021-9-16 13:21:56');

INSERT INTO `stories` VALUES (5, '领养员喂养了我', '2021_11_19.jpg', '2021-11-19 17:22:49');

INSERT INTO `stories` VALUES (6, '今天和小伙伴们玩得很开心！', '2021_4_23.jpg', '2021-4-23 15:13:25');

-- ----------------------------
-- Table structure for userinfo
-- ----------------------------
DROP TABLE IF EXISTS `userinfo`;
CREATE TABLE `userinfo`  (
  `userID` int NOT NULL AUTO_INCREMENT,
  `userName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sign` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '无签名',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  PRIMARY KEY (`userID`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of userinfo
-- ----------------------------
INSERT INTO `userinfo` VALUES (1, 'admin', '1234', '今天也是热爱珊瑚的一天！', '00后-大大咧咧-热情');

SET FOREIGN_KEY_CHECKS = 1;
