pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;
contract Ballot {
    //选民
    struct Voter {
        uint number;    //选票号, 对应候选者编号
        bool isVoted;   //已投票
    }
    //候选者
    struct Candidate {
        uint number;    //候选者编号
        string name;    //名字
        uint count;     //票数
    }
    //候选者们
    Candidate[] candidates;
    //选民们
    mapping(address => Voter) voters;
    //投票发起人
    address chairperson;
    //是否已投票
    function isVoted() public view returns (bool) {
        Voter storage sender = voters[msg.sender];
        return sender.isVoted;
    }
    //候选者们的名字
    string[] names = [
            "亚巴顿",
            "炼金术士",
            "远古冰魄",
            "敌法师",
            "天穹守望者",
            "斧王",
            "祸乱之源",
            "蝙蝠骑士",
            "兽王",
            "嗜血狂魔",
            "赏金猎人",
            "酒仙",
            "钢背兽",
            "育母蜘蛛",
            "半人马战行者",
            "混沌骑士",
            "陈",
            "克林克兹",
            "发条技师",
            "水晶室女",
            "黑暗贤者",
            "邪影芳灵",
            "戴泽",
            "死亡先知",
            "干扰者",
            "末日使者",
            "龙骑士",
            "卓尔游侠",
            "大地之灵",
            "撼地者",
            "上古巨神",
            "灰烬之灵",
            "魅惑魔女",
            "谜团",
            "虚空假面",
            "天涯墨客",
            "矮人直升机",
            "哈斯卡",
            "祈求者",
            "艾欧",
            "杰奇洛",
            "主宰",
            "光之守卫",
            "昆卡",
            "军团指挥官",
            "拉席克",
            "巫妖",
            "噬魂鬼",
            "莉娜",
            "莱恩",
            "德鲁伊",
            "露娜",
            "狼人",
            "马格纳斯",
            "美杜莎",
            "米波",
            "米拉娜",
            "齐天大圣",
            "变体精灵",
            "娜迦海妖",
            "先知",
            "瘟疫法师",
            "暗夜魔王",
            "司夜刺客",
            "食人魔魔法师",
            "全能骑士",
            "神谕者",
            "殁境神蚀者",
            "石鳞剑士",
            "幻影刺客",
            "幻影长矛手",
            "凤凰",
            "帕克",
            "帕吉",
            "帕格纳",
            "痛苦女王",
            "剃刀",
            "力丸",
            "拉比克",
            "沙王",
            "暗影恶魔",
            "影魔",
            "暗影萨满",
            "沉默术士",
            "天怒法师",
            "斯拉达",
            "斯拉克",
            "狙击手",
            "幽鬼",
            "裂魂人",
            "风暴之灵",
            "斯温",
            "工程师",
            "圣堂刺客",
            "恐怖利刃",
            "潮汐猎人",
            "伐木机",
            "修补匠",
            "小小",
            "树精卫士",
            "巨魔战将",
            "巨牙海民",
            "孽主",
            "不朽尸王",
            "熊战士",
            "复仇之魂",
            "剧毒术士",
            "冥界亚龙",
            "维萨吉",
            "术士",
            "编织者",
            "风行者",
            "寒冬飞龙",
            "巫医",
            "冥魂大帝",
            "宙斯"
        ];

    //构造函数
    constructor() public {
        //添加候选者, 候选者编号从0递增
        for (uint i = 0; i < names.length; i++) {
            candidates.push(Candidate({
                number: i,
                name: names[i],
                count: 0
            }));
        }
        chairperson = msg.sender;
    }
    //投票
    function vote(uint _number) public returns (bool) {
        require (_number < candidates.length, "The vote number is out of index.");//选票编号必须小于候选者数量
        Voter storage sender = voters[msg.sender];
        require(!sender.isVoted, "Every voter could vote only once, you have already voted.");//每个选民只能投票一次
        candidates[_number].count++;
        sender.number = _number;
        sender.isVoted = true;
        return true;
    }
    //获得当前选票结果, 返回值是简单数据类型供前端调用
    function getCandidates() public view returns (uint[], string[], uint[]) {
        uint[] memory numbers = new uint[] (candidates.length);
        string[] memory names = new string[] (candidates.length);
        uint[] memory counts = new uint[] (candidates.length);

        for (uint i = 0; i < candidates.length; i++) {
            numbers[i] = candidates[i].number;
            names[i] = candidates[i].name;
            counts[i] = candidates[i].count;
        }
        return(numbers, names, counts);
    }
}