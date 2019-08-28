---
title: gtk+ 实现不规则按钮和透明窗口
id: 133
categories:
  - arm
date: 2013-04-05 01:35:00
tags:
---

![gtk 透明](http://www.madhex.com/data/attachment/forum/201011/25/131752u3yyhr30h3648r63.png "gtk 透明")<!--more-->
`
#include &lt;gtk/gtk.h&gt;

<!-- more -->
gint mouse_event_handle(GtkWidget *widget, GdkEventButton *event, gpointer data)
{
GdkPixbuf *pixbuf;
GdkPixmap *pixmap;
GdkBitmap *bitmap;
GtkWidget *oldImage;
GtkWidget *newImage;
switch(event-&gt;button) {
case 1:
printf("Left ");
break;
case 2:
printf("Middle ");
break;
case 3:
printf("Right ");
break;
default:
printf("Unknown ");
}

switch(event-&gt;type){
case GDK_BUTTON_PRESS:
printf("Mouse button press at (%.2f, %.2f)n", event-&gt;x, event-&gt;y);
oldImage = GTK_WIDGET(gtk_container_children(GTK_CONTAINER(widget))-&gt;data);
gtk_object_ref(GTK_OBJECT(oldImage));
gtk_container_remove(GTK_CONTAINER(widget), oldImage);
pixbuf = gdk_pixbuf_new_from_file ("press.png", NULL);
newImage = gtk_image_new_from_pixbuf (pixbuf);
gdk_pixbuf_render_pixmap_and_mask(pixbuf, &amp;pixmap, &amp;bitmap, 128);
gtk_widget_shape_combine_mask(widget, bitmap, 0, 0);
gtk_container_add(GTK_CONTAINER(widget), newImage);
gtk_widget_show(newImage);
break;
case GDK_BUTTON_RELEASE:
printf("Mouse button release at (%.2f, %.2f)n", event-&gt;x, event-&gt;y);
oldImage = GTK_WIDGET(gtk_container_children(GTK_CONTAINER(widget))-&gt;data);
gtk_object_ref(GTK_OBJECT(oldImage));
gtk_container_remove(GTK_CONTAINER(widget), oldImage);
pixbuf = gdk_pixbuf_new_from_file ("enter.png", NULL);
newImage = gtk_image_new_from_pixbuf (pixbuf);
gdk_pixbuf_render_pixmap_and_mask(pixbuf, &amp;pixmap, &amp;bitmap, 128);
gtk_widget_shape_combine_mask(widget, bitmap, 0, 0);
gtk_container_add(GTK_CONTAINER(widget), newImage);
gtk_widget_show(newImage);
break;
case  GDK_ENTER_NOTIFY:
printf("Mouse enter.n");
oldImage = GTK_WIDGET(gtk_container_children(GTK_CONTAINER(widget))-&gt;data);
gtk_object_ref(GTK_OBJECT(oldImage));
gtk_container_remove(GTK_CONTAINER(widget), oldImage);
pixbuf = gdk_pixbuf_new_from_file ("enter.png", NULL);
newImage = gtk_image_new_from_pixbuf (pixbuf);
gdk_pixbuf_render_pixmap_and_mask(pixbuf, &amp;pixmap, &amp;bitmap, 128);
gtk_widget_shape_combine_mask(widget, bitmap, 0, 0);
gtk_container_add(GTK_CONTAINER(widget), newImage);
gtk_widget_show(newImage);
break;
case GDK_LEAVE_NOTIFY:
printf("Mouse leave.n");
oldImage = GTK_WIDGET(gtk_container_children(GTK_CONTAINER(widget))-&gt;data);
gtk_object_ref(GTK_OBJECT(oldImage));
gtk_container_remove(GTK_CONTAINER(widget), oldImage);
pixbuf = gdk_pixbuf_new_from_file ("leave.png", NULL);
newImage = gtk_image_new_from_pixbuf (pixbuf);
gdk_pixbuf_render_pixmap_and_mask(pixbuf, &amp;pixmap, &amp;bitmap, 128);
gtk_widget_shape_combine_mask(widget, bitmap, 0, 0);
gtk_container_add(GTK_CONTAINER(widget), newImage);
gtk_widget_show(newImage);
break;
default:
printf("n");
break;
}
return FALSE;
}

int main(int argc, char *argv[])
{
GtkWidget *window = NULL;
GdkPixbuf *pixbuf = NULL;
GdkPixmap *pixmap = NULL;
GdkBitmap *bitmap = NULL;

GtkWidget *image = NULL;
GtkWidget *eventbox = NULL;
GtkWidget *fixed = NULL;

gtk_init(&amp;argc,&amp;argv);

window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
gtk_window_set_title(GTK_WINDOW(window),"ZQButton  Demo");
gtk_widget_set_events(window, GDK_SCROLL_MASK);
gtk_widget_set_app_paintable(window,TRUE);
gtk_widget_realize (window);
//gtk_window_fullscreen(GTK_WINDOW(window));
gtk_widget_set_size_request(window, 800, 600);
g_signal_connect (G_OBJECT (window), "delete_event", G_CALLBACK (gtk_main_quit), NULL);

fixed = gtk_fixed_new();
gtk_container_add (GTK_CONTAINER(window), fixed);
pixmap = gdk_pixmap_new (fixed-&gt;window, 800, 600, -1);

// gdk_window_set_back_pixmap (fixed-&gt;window, pixmap, FALSE);
gtk_widget_show(fixed);

eventbox=gtk_event_box_new();
gtk_widget_set_events(eventbox, GDK_MOTION_NOTIFY | GDK_BUTTON_PRESS | GDK_BUTTON_RELEASE
| GDK_ENTER_NOTIFY | GDK_LEAVE_NOTIFY);

g_signal_connect(G_OBJECT(eventbox), "button_press_event", GTK_SIGNAL_FUNC(mouse_event_handle), NULL);
g_signal_connect(G_OBJECT(eventbox), "button_release_event", GTK_SIGNAL_FUNC(mouse_event_handle), NULL);
g_signal_connect(G_OBJECT(eventbox), "enter_notify_event", GTK_SIGNAL_FUNC(mouse_event_handle), NULL);
g_signal_connect(G_OBJECT(eventbox), "leave_notify_event", GTK_SIGNAL_FUNC(mouse_event_handle), NULL);
gtk_fixed_put (GTK_FIXED (fixed), eventbox, 10, 10);
pixbuf = gdk_pixbuf_new_from_file ("leave.png", NULL);
image = gtk_image_new_from_pixbuf (pixbuf);
gdk_pixbuf_render_pixmap_and_mask(pixbuf, &amp;pixmap, &amp;bitmap, 128);
gtk_widget_shape_combine_mask(eventbox, bitmap, 0, 0);
gtk_widget_shape_combine_mask(window, bitmap, 10, 10);
gtk_container_add(GTK_CONTAINER(eventbox), image);
gtk_widget_show(image);
gtk_widget_show(eventbox);

gtk_widget_show(window);
gtk_main();
return FALSE;
}`
