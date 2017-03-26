title: 使用 HTML5 原生表单验证来控制 Ajax 请求的发送
date: 2015-9-22 19:02:10
categories: "JavaScript"

---

&nbsp;&nbsp;&nbsp;&nbsp;HTML5 原生的表单验证默认是针对 form 表单的请求行为的，但是有时候我们在发送 ajax 请求时也需要用到原生表单的验证功能，具体例子如下：

```html
<form onsubmit="return false;" id="myform"> //绑定 onsubmit 事件阻止原生表单请求
    用户名：<input name="username" type="text" required maxlength="10" />
    密码:   <input name="password" type="password" />
    <input type="submit" value="提交" id="submit_btn" />
</form>

<script>
    var myform = document.getElementById('myform'),
        btn    = document.getElementById('submit_btn');
    var isValid; //定义一个全局变量存储表单是否正确
    
    myform.addEventListener('invalid', function() { //注册 invalid 事件，表单验证不通过时触发
        isValid = false;
    }, true);
    
    var sendRequest = function() { //将 ajax 请求写成一个函数，并在里面判断表单验证是否通过，通过则发送请求
        if(isValid) {
            /*
            ajax 请求代码
            */
        }
    };
    
    btn.addEventListener('click', function() {
        isValid = true; //默认表单是正确的
        setTimeout(sendRequest, 0); 
        /*这里是一个重点，必须使用一个 setTimeout 来调用请求函数，这是因为 DOM 事件，Ajax，SetTimeout 都是异步执行，上面注册的 invalid 事件里面，它的回调函数的执行是异步的，所以如果这里不使用 setTimeout 将请求发送函数放入回调队列里面，就会由于变量 isValid 的值默认是 true 而使得表单验证一直都是通过的状态*/
    }, false);
    
</script>
```






