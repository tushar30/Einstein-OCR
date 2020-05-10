public class EinsteinOCR {

    public static string getAccessToken() {
        ContentVersion base64Content = [SELECT Title, VersionData FROM ContentVersion where Title='einstein_platform' OR Title='predictive_services' ORDER BY Title LIMIT 1];
        String keyContents = base64Content.VersionData.tostring();
        keyContents = keyContents.replace('-----BEGIN RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('-----END RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('\n', '');
        
        // Get a new token
        JWT jwt = new JWT('RS256');
        // jwt.cert = 'JWTCert'; // Uncomment this if you used a Salesforce certificate to sign up for an Einstein Platform account
        jwt.pkcs8 = keyContents; // Comment this if you are using jwt.cert
        jwt.iss = 'developer.force.com';
        jwt.sub = 'tushar@briskminds.com';
        jwt.aud = 'https://api.einstein.ai/v2/oauth2/token';
        jwt.exp = '900';
        String access_token = JWTBearerFlow.getAccessToken('https://api.einstein.ai/v2/oauth2/token', jwt);
        return access_token;
    }

    public static void getImageText() {
        String access_token = getAccessToken();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://api.einstein.ai/v2/vision/ocr');
        req.setHeader('content-type', 'multipart/form-data; charset="UTF-8"; boundary="1ff13444ed8140c7a32fc4e6451aa76d"');
        req.setHeader('Authorization', 'Bearer '+access_token); //replace token with your access token
        
        req.setHeader('Cache-Control', 'no-cache');
        string form64 = '';
        
        form64 += HttpFormBuilder.WriteBoundary();
        form64 += HttpFormBuilder.WriteBodyParameter('sampleLocation', 'https://newstechnologystuff.com/header-design.png');
        form64 += HttpFormBuilder.WriteBoundary();
        form64 += HttpFormBuilder.WriteBodyParameter('modelId', 'OCRModel');
        form64 += HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.CrLf);
        
        blob formBlob = EncodingUtil.base64Decode(form64);
        string contentLength = string.valueOf(formBlob.size());
        
        req.setBodyAsBlob(formBlob);
        req.setHeader('Connection', 'keep-alive');
        req.setHeader('Content-Length', contentLength);
        req.setTimeout(60*1000);
        
        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        System.debug('Status Code: '+res.getStatusCode());
       // System.debug('=='+resp );
        if(res.getStatusCode() == 200) {
            EinteinParser ocr = EinteinParser.parse(resp);  
            for( EinteinParser.Probabilities prob : ocr.probabilities) {
                system.debug('========Label==== '+prob.label);
                system.debug('========BoundingBox==== '+prob.boundingBox);
                system.debug('========probability==== '+prob.probability);
            }        
        }
        
    }
    
    public static void getBusinessCardText() {
        String access_token = getAccessToken();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://api.einstein.ai/v2/vision/ocr');
        req.setHeader('content-type', 'multipart/form-data; charset="UTF-8"; boundary="1ff13444ed8140c7a32fc4e6451aa76d"');
        req.setHeader('Authorization', 'Bearer '+access_token); //replace token with your access token
        
        req.setHeader('Cache-Control', 'no-cache');
        string form64 = '';
        
        form64 += HttpFormBuilder.WriteBoundary();
        form64 += HttpFormBuilder.WriteBodyParameter('sampleLocation', 'https://newstechnologystuff.com/business-card-translation-samples.jpg');
        form64 += HttpFormBuilder.WriteBoundary();
        form64 += HttpFormBuilder.WriteBodyParameter('modelId', 'OCRModel');
        form64 += HttpFormBuilder.WriteBoundary();
        form64 += HttpFormBuilder.WriteBodyParameter('task', 'contact');
        form64 += HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.CrLf);
        
        blob formBlob = EncodingUtil.base64Decode(form64);
        string contentLength = string.valueOf(formBlob.size());
        
        req.setBodyAsBlob(formBlob);
        req.setHeader('Connection', 'keep-alive');
        req.setHeader('Content-Length', contentLength);
        req.setTimeout(60*1000);
        
        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        System.debug('Status Code: '+res.getStatusCode());

        if(res.getStatusCode() == 200) {
            EinteinParser ocr = EinteinParser.parse(resp);  
            for( EinteinParser.Probabilities prob : ocr.probabilities) {
                system.debug('========Label==== '+prob.label);
                system.debug('========BoundingBox==== '+prob.boundingBox);
                system.debug('========probability==== '+prob.probability);
            }        
        }
        
    }
    
    public static void getTableText() {
        
        String access_token = getAccessToken();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://api.einstein.ai/v2/vision/ocr');
        req.setHeader('content-type', 'multipart/form-data; charset="UTF-8"; boundary="1ff13444ed8140c7a32fc4e6451aa76d"');
        req.setHeader('Authorization', 'Bearer '+access_token); //replace token with your access token
        
        req.setHeader('Cache-Control', 'no-cache');
        string form64 = '';
        
        form64 += HttpFormBuilder.WriteBoundary();
        form64 += HttpFormBuilder.WriteBodyParameter('sampleContent', 'https://newstechnologystuff.com/table.png');
        form64 += HttpFormBuilder.WriteBoundary();
        form64 += HttpFormBuilder.WriteBodyParameter('modelId', 'tabulatev2');
        form64 += HttpFormBuilder.WriteBoundary();
        form64 += HttpFormBuilder.WriteBodyParameter('task', 'table');
        form64 += HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.CrLf);
        
        blob formBlob = EncodingUtil.base64Decode(form64);
        string contentLength = string.valueOf(formBlob.size());
        
        req.setBodyAsBlob(formBlob);
        req.setHeader('Connection', 'keep-alive');
        req.setHeader('Content-Length', contentLength);
        req.setTimeout(60*1000);
        
        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        System.debug('Status Code: '+res.getStatusCode());

        if(res.getStatusCode() == 200) {
            EinteinParser ocr = EinteinParser.parse(resp);  
            for( EinteinParser.Probabilities prob : ocr.probabilities) {
                system.debug('========Label==== '+prob.label);
                system.debug('========BoundingBox==== '+prob.boundingBox);
                system.debug('========probability==== '+prob.probability);
            }        
        }
        
    }

}