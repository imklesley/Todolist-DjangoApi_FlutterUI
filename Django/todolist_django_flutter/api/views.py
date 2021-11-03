from rest_framework.decorators import api_view
from rest_framework.response import Response

from .models import Note
from .serializers import NoteSerializer


@api_view(['GET'])
def get_routes(request):
    routes = [
        {'endpoint': '/notes/',
         'method': 'GET',
         'body': None,
         'description': 'Returns an array of notes'},

        {'endpoint': '/notes/id',
         'method': 'GET',
         'body': None,
         'description': 'Returns a single note object'},

        {'endpoint': '/notes/create/',
         'method': 'POST',
         'body': {'body': ''},
         'description': 'Creates new note with data sent in post method'},

        {'endpoint': '/notes/id/update/',
         'method': 'POST',
         'body': {'body': ''},
         'description': 'Updates an existing note'},

        {'endpoint': '/notes/id/delete/',
         'method': 'POST',
         'body': {'body': ''},
         'description': 'Deletes an existing note'},
    ]

    return Response(routes)


@api_view(['GET'])
def get_notes(request):
    notes = Note.objects.all()
    serializer = NoteSerializer(notes, many=True)
    return Response(serializer.data)


@api_view(['GET'])
def get_note(request, id_note: int):
    note = Note.objects.get(id=id_note)
    serializer = NoteSerializer(note, many=False)
    return Response(serializer.data)


@api_view(['POST'])
def create_note(request):
    data = request.data

    note = Note.objects.create(
        body=data['body']
    )

    serializer = NoteSerializer(note, many=False)

    return Response(serializer.data)


@api_view(['PUT'])
def update_note(request, id_note):
    data = request.data

    note = Note.objects.get(id=id_note)

    note.body = data['body']
    note.save()

    serializer = NoteSerializer(note, many=False)

    return Response(serializer.data)


@api_view(['DELETE'])
def delete_note(request, id_note):
    note = Note.objects.get(id=id_note)
    note.delete()

    return Response('Note was deleted!!')
