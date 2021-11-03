from django.urls import path

from . import views

urlpatterns = [
    path('', views.get_routes, name='routes'),
    path('notes/', views.get_notes, name='notes'),
    path('notes/create', views.create_note, name='create'),
    path('notes/<int:id_note>/', views.get_note, name='note'),
    path('notes/<int:id_note>/update', views.update_note, name='update'),
    path('notes/<int:id_note>/delete', views.delete_note, name='delete'),

]
