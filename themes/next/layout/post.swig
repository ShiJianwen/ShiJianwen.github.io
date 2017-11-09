{% extends '_layout.swig' %}
{% import '_macro/post.swig' as post_template %}
{% import '_macro/sidebar.swig' as sidebar_template %}


{% block title %}{{ page.title }} | {{ config.title }}{% endblock %}

{% block page_class %}page-post-detail{% endblock %}


{% block content %}

  <div id="posts" class="posts-expand">
    {{ post_template.render(page) }}

    <div class="post-spread">
      {% if theme.jiathis %}
        {% include '_partials/share/jiathis.swig' %}
      {% elseif theme.baidushare %}
        {% include '_partials/share/baidushare.swig' %}
      {% elseif theme.add_this_id %}
        {% include '_partials/share/add-this.swig' %}
      {% elseif theme.duoshuo_shortname and theme.duoshuo_share %}
        {% include '_partials/share/duoshuo_share.swig' %}
      {% endif %}
    </div>
  </div>
  <!-- 来必力City版安装代码 -->
  <div id="lv-container" data-id="city" data-uid="MTAyMC8zMTEwOS83NjU4">
    <script type="text/javascript">
    (function(d, s) {
        var j, e = d.getElementsByTagName(s)[0];

        if (typeof LivereTower === 'function') { return; }

        j = d.createElement(s);
        j.src = 'https://cdn-city.livere.com/js/embed.dist.js';
        j.async = true;

        e.parentNode.insertBefore(j, e);
    })(document, 'script');
    </script>
  <noscript> 为正常使用来必力评论功能请激活JavaScript</noscript>
  </div>
  <!-- City版安装代码已完成 -->
  <link rel="stylesheet" href="https://imsun.github.io/gitment/style/default.css">
  <script src="https://imsun.github.io/gitment/dist/gitment.browser.js"></script>


{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(true) }}
{% endblock %}


{% block script_extra %}
  {% include '_scripts/pages/post-details.swig' %}
{% endblock %}
