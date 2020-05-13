<%@ page session="false" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.BufferedReader,java.io.IOException,java.io.InputStream,java.io.InputStreamReader,java.net.URL,java.net.URLConnection"%>
<%!
		    //只在第一个用户访问时执行
		    String text = null;
		    //时间戳
		    long time = 0;
		%>
    		<%
    		//每一次访问都会执行
    	if(System.currentTimeMillis()-time>600000){
    	    //记录获取数据的时间
    	    time = System.currentTimeMillis();
    		    //1.	创建一个网址对象 url 
    		URL url = new URL("https://zaixianke.com/yq/info2");
    		//2.	通过网址对象url, 打开连接,并得到连接对象conn
    		URLConnection conn = url.openConnection();
    		//3.	通过连接对象conn , 获取用于读取网页内容的 输入流 is (读取的内容是字节) 
    		InputStream is = conn.getInputStream();
    		//4.	将上述的字节输入流is , 装饰为字符输入流. 
    		//		再将字符输入流,装饰为能一次读取一行的 缓冲输入流 br
    		BufferedReader br = new BufferedReader(new InputStreamReader(is,"UTF-8"));
    		//5.	通过输入流br ,读取一行文字, 并赋值给变量text
    		text = br.readLine();
    	}	
    		%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta charset="UTF-8">
<title>疫情地图</title>
<script src="https://cdn.bootcss.com/jquery/3.4.1/jquery.min.js"></script>
<script src="https://cdn.bootcss.com/echarts/4.7.0/echarts.min.js"></script>
<script src="http://cdn.zaixianke.com/world.js"></script>
</head>
<body>
<div id="main" style="width: 100%;height:600px;"></div><br>
<div style="text-align:center">
	<a style="color:#333" align="center" href="index.jsp">查看国内疫情</a>&nbsp;&nbsp;
	<a style="color:#333" align="center" href="g_today.jsp">查看全球新增确诊</a>
</div>
<script type="text/javascript">
  var data = <%=text%>;
  // 第3步: 基于容器，创建一个echarts实例
  var myChart = echarts.init(document.getElementById('main'));
  var opt = {
    // 设置标题和副标题及副标题跳转链接
    title: {
      text: '新冠疫情-全球累计数据',
      subtext: '余越出品',
      sublink: 'https://github.com/yuwell1999'
    },
    // 数据提示框
    tooltip: {
      trigger: 'item', // item放到数据区域触发
      //formatter: '{b}<br/>{c} (人)' // 提示数据格式br表示换行，地图 : {a}（系列名称），{b}（区域名称），{c}（合并数值）, {d}（无）
      formatter:function (params, ticket, callback) {
        if(params.data)
          return params.name+'<br/>'+params.data.value+' (人)';
        else
          return params.name+'<br/> 未公布感染人数';
      }
    },
    // 视觉映射方案1：,疫情颜色根据传染病疫情等级分类为5个级别：黄色-橙色-深橙色-红色-深红色
    // 为了是视觉分布更好，可以添加更多的颜色范围，然后适当调小max的值，因为美国和其它国家相差太大
    /**/
    visualMap: {
      min: 1, // 颜色映射对应的最小值，即对应下面的lightskyblue
      max: 300000, // 颜色映射对应的最大值，即对应下面的orangered
      text: ['严重', '轻微'], // 映射图上下标记文本
      realtime: true, // 是否显示拖拽手柄，映射条可以拖拽调整要映射的范围
      calculable: true, // 拖拽时，是否实时更新地图
      inRange: {
        color: ['rgba(222,0,0,0.2)','rgba(160,0,0,1)'] // 颜色映射范围，最小值，过渡值，最大值
      }
    },

    // 具体数据
    series: [
      {
        name: '全球各国确诊病例', // 系列名称
        zoom:1.2,//地图大小
        type: 'map', // 系列类型，地图
        map: 'world', // 要使用的地图，即上面注册的地图名称
        roam: true, // 开启鼠标缩放和平移漫游
        label: { // 图形上的文本标签，地图默认显示数据名
          show: true,
          fontSize:8,
          //formatter: '{b}', // b是数据名，c是数据值
          formatter:function (params, ticket, callback) {
            //公布了数据 且 数据累计数据大于5万的显示国家名称
            if(params.data && params.data.value>50000) {
              return params.name;
            }else{
              return '';
            }
          }
        },
        data: data,
      }
    ]
  };
  myChart.setOption(opt);
</script>
</body>
</html>
    		