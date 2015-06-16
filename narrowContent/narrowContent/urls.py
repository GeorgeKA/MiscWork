from django.conf.urls import patterns, include, url
from django.contrib import admin

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'narrowContent.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
	#url(r'^login/$', 'auth.views.login_user'),
    url(r'^login/$', 'django.contrib.auth.views.login'),
	url(r'^logout/$', 'django.contrib.auth.views.logout'),
)
