date: 2015-04-02 12:00:12
categories: "JavaScript"
title: JavaScript学习笔记之数组的深拷贝
---

&emsp;&emsp;由于JavaScript的数据分为‘原始类型’和‘引用类型’，数组Array是引用类型，与c语言类似，对数组直接用‘=’号赋值的话，赋给变量的值只是该数组的引用地址（c语言中叫指针），并没有实现数组数据的拷贝，两个数组共享同一组数据，也就是说一旦修改这两个数组中的任何一方，该修改也会在另一方体现出来。具体代码如下：
<!-- more -->
错误示例1：

    var arr1 = [1,2,3,4,5],arr2;
    arr2 = arr1;        //简单赋值
    console.log(arr2);  //输出[1,2,3,4,5],说明赋值成功
    arr1.length = 0;    //清空数组1
    console.log(arr2)   //此处输出[]；空数组，说明两个数组共享数据

&emsp;&emsp;要想实现数组的深拷贝，除了for循环遍历赋值外，一维数组还可以使用‘slice’或者'concat'方法：

一维数组深拷贝：

    var arr1 = [1,2,3,4,5],arr2,arr3;
    arr2 = arr1.slice(0);   //使用slice方法
    arr3 = arr1.concat();   //使用concat方法
    arr1.length = 0;        //清空数组1
    console.log('arr2: ' + arr2);   //输出arr2: [1,2,3,4,5]
    console.log('arr3: ' + arr3);   //输出arr3: [1,2,3,4,5]

&emsp;&emsp;关于slice和concat两个方法更详细的内容可以看这里 [slice方法][1]  [concat方法][2]

&emsp;&emsp;对于一维数组来说slice和concat方法能够实现数组的深拷贝，但如果原数组是多维的比如是`[1,2,3,[4,5]]`这样的数组，由于对于二维数组或者多维数组来说，它的第一维元素里面存储的是第二维元素的地址，所以在高维层面的数据依旧是共享的，具体代码如下：

错误示例2：

    var arr1 = [1,2,3,[4,5]],arr2,arr3;
    arr2 = arr1.slice(0);
    arr3 = arr1.concat();
    console.log(arr2[3][1]);    //输出5
    arr1[3][1] = 0;             //改变原数组中的高维元素
    console.log(arr2[3][1]);    //输出0
    console.log(arr3[3][1]);    //输出0
    
&emsp;&emsp;要想实现高维数组的深拷贝，可用JS函数来实现：

多维数组的深拷贝：

    function deepCopy(arr) {
            var result = [];
            for (var i = 0; i < arr.length; i++) {  //遍历原数组
                if (arr[i] instanceof Array){
                    result[i] = deepCopy(arr[i]);   //若数组多维，则递归调用函数
                }
                else result[i] = arr[i];
            }
            return result;
        }
        //现在我们来试试多维数组的深拷贝
        var arr1 = [1,2,3,[4,5,6]],arr2;
        arr2 = deepCopy(arr1);
        arr1[3][0] = 0;     //修改高维元素
        console.log(arr2[3][0]);    //输出4，没有改变

上述函数在JQuery可表示如下：

    arr2 = $.extend(true, {}, arr1);

  [1]: http://www.w3school.com.cn/jsref/jsref_slice_string.asp
  [2]: http://www.w3school.com.cn/jsref/jsref_concat_array.asp