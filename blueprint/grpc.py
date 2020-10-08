from .generated import echo_pb2_grpc, echo_pb2


class Echoer(echo_pb2_grpc.EchoServicer):

    def Reply(self, request, context):
        return echo_pb2.EchoReply(message=f'You said: {request.message}')
