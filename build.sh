#!/bin/sh

BUILD_STAGE=$1

if [[ $BUILD_STAGE == "test" ]]; then
    # test stage account, profile is empty as default credentials for test stage
    AWS_ACCOUNT_ID=223413462631
    echo build $BUILD_STAGE aws account id $AWS_ACCOUNT_ID
    PROFILE=
    REGION="--region us-east-1"
elif [[ $BUILD_STAGE == "prod" ]]; then
    # prod stage account, profile is devLetsData which has the prod account credentials
    AWS_ACCOUNT_ID=956943252347
    echo build $BUILD_STAGE aws account id $AWS_ACCOUNT_ID
    PROFILE="--profile devLetsData"
    REGION="--region us-east-1"
else
    echo "unknown build stage "
    echo $BUILD_STAGE
    exit -1
fi

#build letsdata_javascript_interface
echo "########## starting docker build letsdata_javascript_interface ##############"
docker build --platform linux/amd64 -t letsdata_javascript_interface:$BUILD_STAGE -f dockerfile .
echo "running docker letsdata_javascript_interface"
docker run -e LETS_DATA_STAGE='Test' -p 9000:8080 letsdata_javascript_interface:$BUILD_STAGE &
sleep 3
CONTAINER_ID=`docker ps|grep letsdata_javascript_interface:$BUILD_STAGE|cut -d ' ' -f 1`
echo 'containerId: '$CONTAINER_ID
echo "testing letsdata_javascript_interface"
SINGLE_FILE_PARSER_RESPONSE=`curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"requestId":"65fff00b-460c-4055-a171-f0a8c2e4ae22","interface":"SingleFileParser","function":"parseDocument","letsdataAuth":{"tenantId":"3c25bdbd-c2b1-4b74-9f6a-b18d23e6ade1","userId":"de9eb5a6-a06f-429f-8f75-9a438fe073e1","datasetName":"CommonCrawlDataset","datasetId":"78ce0aa2-9b8c-4534-9170-445d2cfd70af"},"data":{"s3FileType" : "WARC", "fileName" : "dataset_name/data_date/logfile_1.gz", "offsetBytes": 256854 , "content": "WARC/1.0\r\nWARC-Type: conversion\r\nWARC-Target-URI: http://023hrk.com/a/chanpinzhongxin/cp2/104.html\r\nWARC-Date: 2022-05-16T04:40:56Z\r\nWARC-Record-ID: <urn:uuid:f8a15ad2-9d24-42d6-8f7a-7d9431246752>\r\nWARC-Refers-To: <urn:uuid:5232afac-fb10-401c-b522-445db8bdbf2a>\r\nWARC-Block-Digest: sha1:M7TRGS3KUALFLHMGLJSDMER3FDP2Z2Q4\r\nWARC-Identified-Content-Language: zho\r\nContent-Type: text/plain\r\nContent-Length: 3710\r\n\r\n漫步肩关节_重庆鸿瑞铠体育设施有限公司\r\n网站地图\r\n加入收藏\r\n联系我们\r\n您好！欢迎访问重庆鸿瑞铠体育设施有限公司！\r\n优质环保原料\r\n更环保更安全\r\n施工保障\r\n流程严谨、匠心工艺\r\n使用年限\r\n高出平均寿命30%\r\n全国咨询热线\r\n139-9602-7139\r\n网站首页\r\n关于我们\r\n公司介绍 企业文化\r\n产品中心\r\n塑胶跑道 健身设施 篮球场塑胶 羽毛球场塑胶 人造草坪足球场\r\n工程案例\r\n工程案例\r\n新闻动态\r\n行业新闻 企业新闻\r\n在线留言\r\n联系我们\r\n您的位置：主页 > 产品中心 > 健身设施 >\r\n产品中心\r\n塑胶跑道\r\n健身设施\r\n篮球场塑胶\r\n羽毛球场塑胶\r\n人造草坪足球场\r\n推荐产品\r\n透气型塑胶跑道\r\n漫步肩关节\r\n谢家湾篮球场绿色完工\r\n大足科技创新人才公寓羽毛球场EPDM\r\n联系我们\r\n地址：重庆九龙坡区火炬大道渝高城市日记8-16\r\n咨询热线：\r\n139-9602-7139\r\n139-9602-7139\r\n漫步肩关节\r\n发布时间：2020-11-04 11:30人气：\r\n1、埋入地下的器材立柱，应可靠地固接横向支承或支承盘;\r\n2、安装器材的土质，在距地表800 mm深度以内应为紧固系数不小于0.7的Ⅱ类普硬土及其以上的非疏松性和非沙壤土类的地质结构;否则，应将该土质等效处理后，方可安装器材; 注：紧固系数不小于0.7的Ⅱ类普硬土可以用铁锹用力开挖并少数用镐开挖的困难程度来确定。需要用铁锹用力开挖并少数用镐开挖的土质，可视为紧固系数不小于0.7的Ⅱ类普硬土。\r\n3、器材立柱埋入地下的深度：当器材地面以上的高度2000 mm时，应不小于500 mm;器材地面以上的高度1000 mm且2000 mm时，应不小于400 mm;器材地面以上的高度1000 mm时，应不小于300 mm;器材立柱底部以下应有不小于100mm厚度的混凝土支承层;\r\n4、安装室外健身器材各支承立柱混凝土地基坑的水平尺寸，应不小于，且不应将混凝土地基处置为上大下小的形状;\r\n5、浇注室外健身器材地基所使用的混凝土强度应不低于C20，且在地基没有完全凝固前，应有专人监护;\r\n6、室外健身器材安装后，各支承立柱和主体应保证与安装地面垂直，垂直度公差应不大于1/100;\r\n7、距室外健身器材地基外部边缘0.5 m范围的地面应进行硬化处理。\r\n8、室外健身器材距架空高低压电线的水平距离应不小于3 m;5 m;\r\n9、夜间需使用器材的场所，在器材边缘2 m的范围内，光照度应不小于15 lx;\r\n10、室外健身器材应远离易燃、易爆和有毒、有害的物品，场地健身应符合国家有关各项安全方面的规定。\r\n分享到：\r\n上一篇：路径器材\r\n下一篇：乒乓台SMC\r\n推荐资讯\r\n2020-10-21羽毛球场PVC塑胶和塑胶地板区别\r\n2020-10-21塑胶篮球场建设应该注意些什么\r\n2020-10-21塑胶篮球场施工的一些问题\r\n2020-10-21塑胶篮球场一般都可以使用什么材料\r\n2020-10-21塑胶网球场建设项目的详细说明\r\n2020-10-21人造草坪足球场建筑产品特点\r\n2020-10-21硅Pu篮球场发展历程\r\n2020-10-21网球场施工有哪些标准？\r\n关于我们\r\n公司介绍 企业文化\r\n产品中心\r\n塑胶跑道 健身设施 篮球场塑胶 羽毛球场塑胶 人造草坪足球场\r\n工程案例\r\n工程案例\r\n新闻动态\r\n行业新闻 企业新闻\r\n在线留言\r\n联系我们\r\n全国咨询热线\r\n139-9602-7139\r\n邮　箱：772915930@qq.com\r\n地　址：重庆九龙坡区火炬大道渝高城市日记8-16\r\nCopyright © 2002-2020 重庆鸿瑞铠体育设施有限公司 版权所有　地址：重庆九龙坡区火炬大道渝高城市日记8-16　备案号：渝ICP备19012620号-1\r\n在线咨询\r\n微信\r\n139-9602-7139\r\nTOP", "startIndex" : 0, "endIndex" : 4202}}'`

QUEUE_MESSAGE_READER_RESPONSE=`curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"letsdataAuth":{"tenantId":"d5feaf90-71a9-41ee-b1b9-35e4242c3155","datasetName":"TargetUriExtractorSQSReadKinesisWriteJavascript2","datasetId":"0baa5cdfbeb4dc020e0fad6b826a7840","userId":"accb3567-2b6e-41ae-b00d-6ce1f9a58d94"},"data":{"messageBody":"{\"documentMetadata\":{},\"vectors\":{\"docText\":[-0.06922189146280289,-0.02906973659992218,0.06443563103675842,0.03906629607081413,-0.0025647422298789024,0.0064123147167265415,-0.01316127646714449,-0.04389151558279991,-0.07123706489801407,-0.11437387764453888,-0.0450676828622818,-0.060709863901138306,-0.037195779383182526,-0.05122554674744606,-0.028115354478359222,-0.02838125452399254,0.0723707303404808,-0.017468245700001717,0.04015680402517319,-0.07075099647045135,0.008461950346827507,0.08410756289958954,-0.060507725924253464,-0.03072200156748295,-0.018261054530739784,0.04316979646682739,-0.03560541197657585,0.07992479205131531,-0.04714709147810936,0.040742985904216766,0.03271040320396423,0.056796032935380936,-0.011396167799830437,0.035178426653146744,0.09794638305902481,0.04630985110998154,-0.08493942022323608,-0.009929354302585125,0.05303885042667389,0.10048896819353104,-0.0011659295996651053,-0.059870582073926926,-0.0093753132969141,-0.03821156919002533,-0.03877207636833191,-0.09555359184741974,0.05029679462313652,0.0064681535586714745,0.10119681060314178,-0.009844898246228695,-0.05219879746437073,-0.07839355617761612,-0.018244322389364243,0.07072702050209045,0.009563980624079704,0.03188396245241165,-0.08091394603252411,-0.04150642454624176,-0.015851927921175957,-0.04160451143980026,0.02598569542169571,0.019541356712579727,-0.046497561037540436,-0.00973075907677412,-0.09412287175655365,-0.03390371426939964,-0.047024209052324295,0.04228426516056061,0.04520804435014725,-0.13883079588413239,0.04708980768918991,0.03152456134557724,-0.10861783474683762,-0.03324035927653313,0.040717240422964096,0.03148714825510979,0.028288720175623894,-0.09722243249416351,0.050902269780635834,-0.08623084425926208,0.003212743205949664,-0.03446498513221741,0.053064700216054916,0.033314816653728485,-0.029206378385424614,0.015433572232723236,0.04511270672082901,0.02506271004676819,0.10134775191545486,-0.03226058930158615,0.05496920645236969,0.024796010926365852,-0.07949279993772507,-0.041606586426496506,-0.0038236058317124844,0.03478153049945831,0.0356462337076664,0.0328773595392704,-0.04109982028603554,0.05032949149608612,0.013811233453452587,0.007479248568415642,-0.10673637688159943,-0.056973714381456375,-0.04037176072597504,0.08089897781610489,-0.030409017577767372,0.0830257460474968,0.017169833183288574,0.011374506168067455,0.007717466913163662,-0.029940171167254448,-0.015624742023646832,-0.047367800027132034,-0.05239444598555565,-0.011787847615778446,-0.04839431867003441,-0.04896082356572151,0.09908868372440338,-0.02853875607252121,-0.031425245106220245,0.01681576669216156,-0.09674560278654099,-0.03779950737953186,0.027465390041470528,3.309005405753851E-4,0.007179807405918837,8.186083884408869E-33,-0.059616729617118835,0.09530704468488693,0.0277349054813385,0.047740206122398376,-0.013762029819190502,0.025863924995064735,-0.05774012580513954,-5.012054461985826E-4,-0.05076884478330612,0.022146712988615036,-0.07188842445611954,0.09925052523612976,0.002935275435447693,-0.01812770776450634,-0.09393811225891113,-3.3364916453137994E-4,0.021646738052368164,-0.006438116542994976,-0.04194258525967598,-2.42148176766932E-4,-0.05961799994111061,-0.011680965311825275,-0.09727096557617188,-0.013176518492400646,-0.07890594750642776,0.02831239439547062,-0.01980738714337349,0.0069813779555261135,0.08928895741701126,0.04586715251207352,0.010542192496359348,-0.023832382634282112,0.07719187438488007,-0.03136378899216652,-9.263050160370767E-4,0.051129985600709915,-0.039074406027793884,-0.06760632991790771,-0.09975472837686539,-0.07290513813495636,-0.03762747719883919,0.07368195801973343,-0.06499168276786804,0.05292250216007233,0.04776609688997269,0.02780355140566826,0.08246773481369019,0.023729830980300903,0.055889517068862915,-0.03830782324075699,-0.07194875180721283,0.04546239972114563,0.014166041277348995,0.027016283944249153,-0.00848767627030611,-0.012762865982949734,-0.05157364904880524,0.00661010667681694,0.06563647091388702,0.010060450062155724,0.002801031107082963,0.06536468118429184,-0.027217982336878777,0.008042139932513237,0.08975230902433395,-0.07310494780540466,0.02630954422056675,0.015093367546796799,0.04047494754195213,0.039130799472332,0.06150209903717041,0.013036898337304592,0.05237339064478874,0.03751565143465996,0.028032885864377022,0.015180408954620361,0.0718892514705658,-0.01123826578259468,-0.040303245186805725,0.03401598334312439,-0.022138429805636406,-0.10809127986431122,0.07440658658742905,0.02553894743323326,0.11017575860023499,-0.015270654112100601,1.4424575783777982E-4,0.00928804837167263,6.147997337393463E-4,0.03661249577999115,-0.009003017097711563,0.0016355831176042557,-0.039142295718193054,0.055030468851327896,-0.045091427862644196,-7.382781167099658E-33,-0.003978378605097532,-0.06064873933792114,0.009347228333353996,-0.01627492532134056,-0.020771019160747528,-0.005131191574037075,0.05283461511135101,0.02732226252555847,0.04314958676695824,0.0273138377815485,0.05658531188964844,-0.0606178380548954,-0.03174124285578728,-0.08524639159440994,-0.022482722997665405,0.007268325425684452,-0.06339950859546661,0.008807409554719925,-0.04719158262014389,0.06770455837249756,-0.05148923769593239,0.04021289199590683,-0.05565234646201134,0.13020747900009155,-0.09059136360883713,0.058581672608852386,-0.022787051275372505,-0.003282849909737706,-0.04966556280851364,0.07966538518667221,0.02245347946882248,-0.059873517602682114,-0.08708104491233826,0.08071983605623245,-0.0712367594242096,0.013621889986097813,0.07027887552976608,0.08477423340082169,0.060701847076416016,0.030501309782266617,0.0894656628370285,-0.08708778768777847,0.028410661965608597,0.0588151291012764,-0.040529295802116394,0.028538960963487625,-0.01409701444208622,0.023977188393473625,-0.032832689583301544,-0.04515118524432182,-0.03971399366855621,0.004435784183442593,-0.06879908591508865,0.025924205780029297,0.05988788977265358,-3.017647486558417E-6,0.09447856992483139,-0.04815742000937462,-0.029411960393190384,-0.01854221150279045,0.039702922105789185,0.0311566311866045,0.005899548530578613,0.1152244284749031,0.10158979892730713,0.04326631873846054,-0.0650814026594162,-0.03302348405122757,0.018551236018538475,0.002690305234864354,-0.0710788145661354,0.004079275764524937,-0.010312777012586594,-0.10719560831785202,0.013608260080218315,0.015002214349806309,-0.027323288843035698,-0.060269132256507874,-0.039668019860982895,0.07289714366197586,0.09579988569021225,-0.05420950800180435,-0.028720542788505554,0.04561933875083923,0.022547747939825058,0.0018199868500232697,-0.02821212075650692,-0.023170629516243935,0.06601710617542267,-0.005553494207561016,-0.02949003502726555,-0.006424409803003073,-0.058014173060655594,-0.04344785958528519,-0.06888695061206818,-5.487893517397424E-8,0.03085474856197834,0.044558335095644,0.0901317447423935,0.01908186636865139,-0.02396944910287857,-0.024306507781147957,0.05976387485861778,0.0664617270231247,9.534814162179828E-4,0.08852450549602509,-0.06564661115407944,-0.02063346467912197,0.031669776886701584,-0.024603504687547684,-0.0048477002419531345,-0.02325066737830639,0.03464483842253685,0.004693953320384026,0.00844524335116148,-0.05450992286205292,0.003098880872130394,0.027680503204464912,0.07872909307479858,0.03695632144808769,0.012963312678039074,-0.01656045764684677,0.06366630643606186,0.07146209478378296,0.04838765785098076,-0.0676516517996788,-0.0383460707962513,-0.018579022958874702,0.01260284148156643,0.07503694295883179,0.020138759166002274,-0.04821883887052536,-0.07575501501560211,0.005583128891885281,-0.13197551667690277,-0.09136348217725754,-0.026977816596627235,-0.0032031123992055655,-0.029335815459489822,-0.027522660791873932,0.031823206692934036,-0.03025422804057598,-0.0031267490703612566,0.0396508052945137,0.08639121055603027,-0.011334463022649288,0.013071057386696339,-0.08855453133583069,0.08498790860176086,0.008780640549957752,0.011720448732376099,-0.04663076624274254,-4.902681685052812E-4,-0.030822107568383217,-0.006447899155318737,0.0021873104851692915,0.041702259331941605,0.00783104170113802,-0.053130846470594406,0.01347342412918806]},\"partitionKey\":\"http://crainhotoil.com/contact/\",\"blockDigest\":\"sha1:ZB4CQB3ZCQTXAEQ5N7AFQ4ABXTNFHX4R\",\"docId\":\"http://crainhotoil.com/contact/\",\"recordType\":\"Content\",\"language\":\"eng\",\"documentId\":\"http://crainhotoil.com/contact/\",\"contentType\":\"text/plain\",\"warcDate\":\"2022-05-16T05:05:23Z\",\"url\":\"http://crainhotoil.com/contact/\"}","messageAttributes":{},"messageId":"c3104aa6-9611-4422-822c-7d91cad99da4"},"requestId":"eb0c3168-6837-45c1-bd74-86e63358e5fb","function":"parseMessage","interface":"QueueMessageReader"}'`

KINESIS_RECORD_READER_RESPONSE=`curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"letsdataAuth":{"tenantId":"d5feaf90-71a9-41ee-b1b9-35e4242c3155","datasetName":"CommonCrawlKinesisReadSagemakerComputeAndSQSWriteJavascript6","datasetId":"8f56b8a14dded436938e8a779a1b2eb9","userId":"accb3567-2b6e-41ae-b00d-6ce1f9a58d94"},"data":{"streamArn":"arn:aws:kinesis:us-east-1:223413462631:stream/tldwcb4c9739a4f17554f7cb8f9904a08b1f7","shardId":"shardId-000000000000","partitionKey":"http://www.masterclasselsalvador.ecosmetics.com.br/counterconversioncbfe/adaefe1487718.html","sequenceNumber":"49647074712966917668584929790277465207800779252898463746","approximateArrivalTimestamp":1701785944187,"data":"{\"documentMetadata\":{},\"partitionKey\":\"http://www.masterclasselsalvador.ecosmetics.com.br/counterconversioncbfe/adaefe1487718.html\",\"blockDigest\":\"sha1:4HQLYTOSTEL33SCUMEZUWAWUTTHZHEZR\",\"docText\":\"ビームス　春物 薄手テーラードジャケット　カモフラ　グレー人によっては　黒 アウター\\nビームス　春物 薄手テーラードジャケット　カモフラ　グレー人によっては　黒\\nメンズ\\nジャケット\\nアウター\\nモッズコート\\n300円\\nビームス\",\"docId\":\"http://www.masterclasselsalvador.ecosmetics.com.br/counterconversioncbfe/adaefe1487718.html\",\"recordType\":\"Content\",\"language\":\"jpn,eng\",\"documentId\":\"http://www.masterclasselsalvador.ecosmetics.com.br/counterconversioncbfe/adaefe1487718.html\",\"contentType\":\"text/plain\",\"warcDate\":\"2022-05-16T05:23:39Z\",\"url\":\"http://www.masterclasselsalvador.ecosmetics.com.br/counterconversioncbfe/adaefe1487718.html\"}"},"requestId":"d8d0c474-f93f-4831-a62c-37770ee6ab40","function":"parseMessage","interface":"KinesisRecordReader"}'`
SAGEMAKER_EXTRACT_RESPONSE=`curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"letsdataAuth":{"tenantId":"d5feaf90-71a9-41ee-b1b9-35e4242c3155","datasetName":"CommonCrawlKinesisReadSagemakerComputeAndSQSWriteJavascript6","datasetId":"8f56b8a14dded436938e8a779a1b2eb9","userId":"accb3567-2b6e-41ae-b00d-6ce1f9a58d94"},"data":{"document":{"documentMetadata":{},"partitionKey":"http://archiv.netky.sk/clanok/foto-emancipacia-silnie-mladych-spanielov-v-skole-ucia-zehlit-a-varit","blockDigest":"sha1:EZXS6RES7KLRMNY6LU4W5LHJYDZ66UOG","docText":"FOTO: Emancipácia silnie, mladých Španielov v škole učia žehliť a variť\nOdosielam na server ...\n All Rights Reserved.\t\n2020 Netky. All Rights Reserved.\t\nKliknutím zavriete","docId":"http://archiv.netky.sk/clanok/foto-emancipacia-silnie-mladych-spanielov-v-skole-ucia-zehlit-a-varit","recordType":"Content","language":"slk","documentId":"http://archiv.netky.sk/clanok/foto-emancipacia-silnie-mladych-spanielov-v-skole-ucia-zehlit-a-varit","contentType":"text/plain","warcDate":"2022-05-16T05:33:13Z","url":"http://archiv.netky.sk/clanok/foto-emancipacia-silnie-mladych-spanielov-v-skole-ucia-zehlit-a-varit"}},"requestId":"6d84f4b4-5f3b-4220-9716-8331e5416277","function":"extractDocumentElementsForVectorization","interface":"SagemakerVectorsInterface"}'`

SAGEMAKER_VECTORS_RESPONSE=`curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"letsdataAuth":{"tenantId":"d5feaf90-71a9-41ee-b1b9-35e4242c3155","datasetName":"CommonCrawlKinesisReadSagemakerComputeAndSQSWriteJavascript6","datasetId":"8f56b8a14dded436938e8a779a1b2eb9","userId":"accb3567-2b6e-41ae-b00d-6ce1f9a58d94"},"data":{"documentInterface":{"documentMetadata":{},"partitionKey":"http://216.92.164.195/index.php?option=com_content&view=article&id=209:2020-10-03-23-41-08&catid=1:latest-news&Itemid=50","blockDigest":"sha1:52JGNEHTC6P735LO3C4HZX7C76OGGODB","docText":"Per què hi ha més homes amb Covid greu? All Rights Reserved.\nJoomla! is Free Software released under the GNU/GPL License.","docId":"http://216.92.164.195/index.php?option=com_content&view=article&id=209:2020-10-03-23-41-08&catid=1:latest-news&Itemid=50","recordType":"Content","language":"cat,eng","documentId":"http://216.92.164.195/index.php?option=com_content&view=article&id=209:2020-10-03-23-41-08&catid=1:latest-news&Itemid=50","contentType":"text/plain","warcDate":"2022-05-16T04:17:02Z","url":"http://216.92.164.195/index.php?option=com_content&view=article&id=209:2020-10-03-23-41-08&catid=1:latest-news&Itemid=50"},"vectorsMap":{"docText":[0.008481191471219063,-0.014781179837882519,-0.07312808930873871,-0.06381141394376755,-0.06091597303748131,-0.017315080389380455,-0.037221167236566544,0.09807809442281723,0.022220248356461525,0.07921756058931351,0.04845413193106651,-0.019079962745308876,0.007391175255179405,0.045232195407152176,-0.03742474690079689,-0.0677088126540184,-0.04844483360648155,-0.03764600306749344,0.014881317503750324,0.13542091846466064,0.010433287359774113,0.006001241505146027,-0.01237453706562519,0.014033321291208267,-0.04794846102595329,0.01707042008638382,-0.04536353796720505,0.01839633658528328,-0.1205870732665062,-0.017149100080132484,-0.006511378102004528,0.05705510079860687,0.03351461514830589,-0.023194709792733192,0.028429239988327026,-0.02423218823969364,0.039436399936676025,-0.054743923246860504,-0.01727886125445366,0.08651707321405411,-0.038440968841314316,0.016916826367378235,0.0089721092954278,0.01705205626785755,-0.005881147459149361,-0.07790748029947281,-0.06295232474803925,-0.01577063277363777,-0.004192774184048176,-0.005422190297394991,-0.06463880091905594,-0.059690169990062714,0.011984344571828842,0.07759343832731247,-0.039988234639167786,-0.017353562638163567,-0.0746721550822258,-0.0436614491045475,0.05645662918686867,-0.0014006340643391013,-0.005116096697747707,0.07157497853040695,-0.01441249530762434,0.04539128765463829,0.04711177572607994,-0.024032287299633026,0.008413111791014671,-0.033367354422807693,0.0628671646118164,0.005185319110751152,0.06889624893665314,-0.06739729642868042,-0.05693661421537399,0.08608753234148026,0.0037484648637473583,0.09224841743707657,0.02304098941385746,0.003972119651734829,0.06288821995258331,-0.14559312164783478,0.00985611043870449,0.05022517591714859,0.07707847654819489,0.015536187216639519,-0.028547413647174835,0.002944018691778183,-0.00028958130860701203,0.07205411046743393,-0.008793629705905914,-0.015018442645668983,0.09189796447753906,-0.04179774224758148,-0.024177754297852516,-0.013109942898154259,0.021277032792568207,-0.03396104276180267,0.04149695113301277,-0.050487492233514786,0.0609506256878376,-0.02163776010274887,-0.0027563858311623335,-0.02690029889345169,0.006001228466629982,0.06831014901399612,-0.0544060580432415,-0.0010083302622660995,0.003952316474169493,-0.01473402138799429,-0.029892709106206894,0.024763071909546852,-0.073275126516819,0.04223025217652321,0.0015831292839720845,-0.07293755561113358,-0.011439835652709007,0.0533638671040535,0.03631633520126343,-0.05046289786696434,0.08835145086050034,-0.052323486655950546,0.015364373102784157,-0.07407183200120926,0.060151152312755585,-0.10330912470817566,0.10232608765363693,0.03281029313802719,-0.012845363467931747,7.724692800819521e-33,-0.013566735200583935,-0.07260658591985703,0.013952689245343208,-0.005160846747457981,0.04498937353491783,0.034713972359895706,0.006564175244420767,0.036681175231933594,0.027682648971676826,-0.08953410387039185,-0.07333368062973022,0.07181502878665924,-0.025888217613101006,-0.004354880657047033,0.010323097929358482,0.06361518055200577,0.03269697725772858,-0.03265983611345291,-0.09659545868635178,0.03521929308772087,-0.0002921128470916301,0.026521144434809685,0.07087329030036926,0.007118057459592819,-0.025274259969592094,-0.0004440542543306947,-0.07696884125471115,-0.020477652549743652,0.0022977397311478853,0.018256787210702896,0.0038980823010206223,-0.06161889433860779,0.013026704080402851,0.0038519350346177816,-0.03560853376984596,0.0029757963493466377,0.0092949653044343,-0.022154778242111206,0.0033910044003278017,0.019690681248903275,-0.004876212682574987,0.0407918281853199,0.05568716675043106,-0.014978530816733837,0.08362159878015518,-0.05625201016664505,-0.056352920830249786,-0.018654288724064827,-0.0019274180522188544,0.04268072918057442,-0.04888371750712395,-0.01613382063806057,-0.053040262311697006,-0.032914016395807266,-0.02859257347881794,0.08706043660640717,-0.05586326867341995,-0.004001315217465162,-0.01881164312362671,0.032713036984205246,0.027752786874771118,0.04714469984173775,0.0022266691084951162,0.02704215794801712,-0.02567577362060547,-0.08730646222829819,0.006233894266188145,-0.06253045797348022,0.09175963699817657,0.05134519562125206,-0.06874165683984756,-0.07181143015623093,0.04618357867002487,-0.015276635065674782,0.05104699730873108,0.008058581501245499,-0.06252243369817734,0.025302274152636528,-0.07220618426799774,-0.008695393800735474,-0.017667537555098534,-0.026189686730504036,-0.036401670426130295,0.03275810182094574,0.037071432918310165,-0.02653714083135128,0.031081484630703926,0.0011732355924323201,-0.09468080848455429,0.014840478077530861,0.05003855377435684,0.05511113628745079,0.08902318775653839,0.01438732910901308,0.01945818029344082,-9.430498938387806e-33,-0.09304174780845642,0.005362011957913637,-0.02840227261185646,-0.028421320021152496,-0.025731490924954414,0.057342495769262314,0.03649713471531868,-0.04541635513305664,-0.0003803145373240113,-0.13706500828266144,0.029194625094532967,0.010554436594247818,0.04648248851299286,-0.058736130595207214,-0.0789276659488678,0.12013042718172073,-0.07488798350095749,-0.05562439560890198,-0.09043444693088531,0.00814158096909523,-0.03371695429086685,0.0978708490729332,-0.061137668788433075,-0.0412907600402832,0.0544062964618206,-0.02014632150530815,0.0906926617026329,0.05777411907911301,0.009772450663149357,-0.0008902248227968812,0.03330308198928833,0.09239733964204788,-0.08438435941934586,0.07080249488353729,0.015190772712230682,-0.02194339968264103,0.07475735247135162,-0.02608150616288185,-0.03066951595246792,-0.021075742319226265,0.07291218638420105,0.0940379723906517,-0.019752120599150658,-0.06481172889471054,0.03452416881918907,0.12203212827444077,0.03344685956835747,-0.06167735159397125,0.07222043722867966,-0.007504958193749189,0.025323692709207535,-0.04989439994096756,-0.0725235864520073,0.002573929261416197,0.011263471096754074,-0.09874062985181808,-0.014069394208490849,-0.04559720680117607,-0.11760471016168594,0.03244165703654289,0.0306599922478199,0.05591799318790436,-0.07525476068258286,-0.01621355675160885,0.10524582117795944,0.00027477520052343607,-0.023374106734991074,0.018692340701818466,0.03753085806965828,-0.023420853540301323,-0.04014870151877403,-0.03228667005896568,-0.00860423780977726,-0.08260325342416763,0.005367610603570938,-0.032659947872161865,-0.06903403997421265,-0.009251726791262627,0.0033750899601727724,-0.032813843339681625,-0.06628528237342834,-0.0764191746711731,-0.004225082695484161,-0.02892543561756611,0.022938724607229233,-0.014200817793607712,-0.023741161450743675,0.021769516170024872,-0.010881269350647926,0.08167600631713867,-0.037814658135175705,0.015682578086853027,-0.018567929044365883,-0.04678083956241608,0.01355689950287342,-5.86829997928362e-8,0.11284206807613373,-0.03861432895064354,-0.0010519883362576365,-0.007124057970941067,-0.02211010456085205,-0.04803244397044182,-0.05319983884692192,0.059788499027490616,0.03118680603802204,0.15355366468429565,-0.02021774835884571,0.0905531644821167,-0.03642740473151207,-0.04069105535745621,-0.061460912227630615,0.03076588548719883,0.03046559914946556,0.08976153284311295,-0.08960892260074615,-0.06727433949708939,0.08541947603225708,-0.008763954043388367,-0.11799905449151993,-0.02860417775809765,0.009188571013510227,-0.03946680575609207,0.040431685745716095,-0.04531360790133476,-0.03747737407684326,-0.06377482414245605,-0.0178538765758276,-0.016486484557390213,-0.016234062612056732,-0.06349398195743561,-0.011540147475898266,-0.06105047091841698,0.10980714112520218,-0.0013562962412834167,0.04620664194226265,0.055810458958148956,0.09858182072639465,-0.10446241497993469,-0.059067223221063614,-0.06542959809303284,-0.0025109387934207916,-0.02818315103650093,-0.002754204673692584,0.045165516436100006,0.03466843068599701,-0.02702287957072258,-0.054758451879024506,-0.008490996435284615,0.035668548196554184,-0.07751739025115967,-0.021814892068505287,0.04985832795500755,0.027297794818878174,-0.0105862095952034,-0.015807799994945526,-0.020262135192751884,0.09815628081560135,0.025388212874531746,0.04291205480694771,0.008899969048798084]}},"requestId":"ef91c26b-6072-4239-bd38-3cee003ef933","function":"constructVectorDoc","interface":"SagemakerVectorsInterface"}'`
DYNAMODBSTREAMS_PARSE_RESPONSE=`curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"requestId":"65fff00b-460c-4055-a171-f0a8c2e4ae22","interface":"DynamoDBStreamsRecordReader","function":"parseRecord","letsdataAuth":{"tenantId":"3c25bdbd-c2b1-4b74-9f6a-b18d23e6ade1","userId":"de9eb5a6-a06f-429f-8f75-9a438fe073e1","datasetName":"CommonCrawlDataset","datasetId":"78ce0aa2-9b8c-4534-9170-445d2cfd70af"},"data":{"streamArn":"arn:aws:dynamodb:us-east-1:223413462631:table/Test_Table/stream/2023-08-01T03:03:57.926","shardId":"shardId-00000001702648559289-e00833cb","eventId":"2324921400000000024335226580","eventName":"MODIFY","identityPrincipalId":"dynamodb.amazonaws.com","identityType":"Service","sequenceNumber":"2324921400000000024335226580","sizeBytes":1234,"streamViewType":"NEW_AND_OLD_IMAGES","approximateCreationDateTime":1702839323,"data":{"keys":{"key1":"value1","key2":"value2"},"oldImage":{"key1":"value1","key2":"value2","attrib1":"attribVal1"},"newImage":{"key1":"value1","key2":"value2","attrib1":"attribVal1","attrib2":"attribVal2"}}}}'`
DYNAMODBTABLE_PARSE_RESPONSE=`curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"requestId":"65fff00b-460c-4055-a171-f0a8c2e4ae22","interface":"DynamoDBTableItemReader","function":"parseDynamoDBItem","letsdataAuth":{"tenantId":"3c25bdbd-c2b1-4b74-9f6a-b18d23e6ade1","userId":"de9eb5a6-a06f-429f-8f75-9a438fe073e1","datasetName":"CommonCrawlDataset","datasetId":"78ce0aa2-9b8c-4534-9170-445d2cfd70af"},"data":{"tableName":"Test_Table","segmentNumber":1,"data":{"keys":{"key1":"value1","key2":"value2"},"item":{"key1":"value1","key2":"value2","attrib1":"attribVal1"}}}}'`

echo "killing letsdata_javascript_interface container"
docker kill $CONTAINER_ID
if [[ $SINGLE_FILE_PARSER_RESPONSE == *"http://023hrk.com/a/chanpinzhongxin/cp2/104.html"* ]]; then
    echo "letsdata_javascript_interface single file parser test passed"
else
    echo "letsdata_javascript_interface single file parser response is not expected"
    echo "response: "
    echo $SINGLE_FILE_PARSER_RESPONSE    
    ERROR=TRUE
fi

if [[ $QUEUE_MESSAGE_READER_RESPONSE == *"http://crainhotoil.com/contact/"* ]]; then
    echo "letsdata_javascript_interface queue message reader test passed"
else
    echo "letsdata_javascript_interface queue message reader response is not expected"
    echo "response: "
    echo $QUEUE_MESSAGE_READER_RESPONSE    
    ERROR=TRUE
fi

if [[ $KINESIS_RECORD_READER_RESPONSE == *"http://www.masterclasselsalvador.ecosmetics.com.br/counterconversioncbfe/adaefe1487718.html"* ]]; then
    echo "letsdata_javascript_interface kinesis record reader test passed"
else
    echo "letsdata_javascript_interface kinesis record reader response is not expected"
    echo "response: "
    echo $KINESIS_RECORD_READER_RESPONSE    
    ERROR=TRUE
fi

if [[ $SAGEMAKER_EXTRACT_RESPONSE == *"All Rights Reserved"* ]]; then
    echo "letsdata_javascript_interface sagemaker extract test passed"
else
    echo "letsdata_javascript_interface sagemaker extract response is not expected"
    echo "response: "
    echo $SAGEMAKER_EXTRACT_RESPONSE    
    ERROR=TRUE
fi

if [[ $SAGEMAKER_VECTORS_RESPONSE == *"http://216.92.164.195/index.php?option=com_content&view=article&id=209:2020-10-03-23-41-08&catid=1:latest-news&Itemid=50"* ]]; then
    echo "letsdata_javascript_interface sagemaker vectors test passed"
else
    echo "letsdata_javascript_interface sagemaker vectors response is not expected"
    echo "response: "
    echo $SAGEMAKER_VECTORS_RESPONSE    
    ERROR=TRUE
fi

if [[ $DYNAMODBSTREAMS_PARSE_RESPONSE == *"value1|value2"* ]]; then
    echo "letsdata_python_interface dynamodb streams record reader test passed"
else
    echo "letsdata_python_interface dynamodb streams record reader response is not expected"
    echo "response: "
    echo $DYNAMODBSTREAMS_PARSE_RESPONSE    
    ERROR=TRUE
fi

if [[ $DYNAMODBTABLE_PARSE_RESPONSE == *"value1|value2"* ]]; then
    echo "letsdata_python_interface dynamodb table item reader test passed"
else
    echo "letsdata_python_interface dynamodb table item reader response is not expected"
    echo "response: "
    echo $DYNAMODBTABLE_PARSE_RESPONSE
    ERROR=TRUE
fi

#ERROR=NONE
if [[ $ERROR == *"TRUE"* ]]; then
    exit 1
else
    echo "all tests passed"
fi


echo "uploading to ecr repo letsdata_javascript_interface"
aws ecr get-login-password $REGION $PROFILE | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com
#REPOSITORY_URI=`aws ecr create-repository --repository-name letsdata_javascript_functions --image-scanning-configuration scanOnPush=true --image-tag-mutability MUTABLE $REGION $PROFILE| jq .repository.repositoryUri`
REPOSITORY_URI=$AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/letsdata_javascript_functions
echo "repository uri "$REPOSITORY_URI
docker tag letsdata_javascript_interface:$BUILD_STAGE $REPOSITORY_URI:latest
docker push $REPOSITORY_URI:latest

aws lambda update-function-code --function-name TestLetsDataJavascriptInterfaceLambdaFunction --image-uri 223413462631.dkr.ecr.us-east-1.amazonaws.com/letsdata_javascript_functions:latest
aws lambda invoke --function-name TestLetsDataJavascriptInterfaceLambdaFunction --invocation-type RequestResponse --payload eyJyZXF1ZXN0SWQiOiI2NWZmZjAwYi00NjBjLTQwNTUtYTE3MS1mMGE4YzJlNGFlMjIiLCJpbnRlcmZhY2UiOiJTaW5nbGVGaWxlUGFyc2VyIiwiZnVuY3Rpb24iOiJnZXRTM0ZpbGVUeXBlIiwibGV0c2RhdGFBdXRoIjp7InRlbmFudElkIjoiM2MyNWJkYmQtYzJiMS00Yjc0LTlmNmEtYjE4ZDIzZTZhZGUxIiwidXNlcklkIjoiZGU5ZWI1YTYtYTA2Zi00MjlmLThmNzUtOWE0MzhmZTA3M2UxIiwiZGF0YXNldE5hbWUiOiJDb21tb25DcmF3bERhdGFzZXQiLCJkYXRhc2V0SWQiOiI3OGNlMGFhMi05YjhjLTQ1MzQtOTE3MC00NDVkMmNmZDcwYWYifSwiZGF0YSI6e319 ./out

echo "########## letsdata_javascript_interface built ##############"
echo "########################"
echo "########################"
echo "########################"
