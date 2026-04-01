@isTest
public class AWSCalloutMock implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest red){
        Map<String, Object> innerBody = new Map<String, Object>{
            'score'          => 100,
            'recommendation' => 'Call now',
            'suggestion'     => 'High quality lead - call imediately.',
            'emailDraft'     => 'Hello world...'
        };

        Map<String,Object> outerBody = new Map<String,Object>{
            'statusCode' => 200,
            'body'      => JSON.serialize(innerBody)
        };

        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody(JSON.serialize(outerBody));
        res.setHeader('Content-Type', 'application/json');
        return res;
    }
}